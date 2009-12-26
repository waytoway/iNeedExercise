class AccountController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie 
  before_filter :find_user
  
  def index
    
  end
  
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    @tmp_user = session[:user]
    puts self.current_user.id
    if logged_in?
      session[:user]=self.current_user.id
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'main', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
      redirect_to(:controller => 'account', :action => 'login')
    end
  end
  
  def signup
    if logged_in?
      logout
    end
    @user = User.new(params[:user])
    return unless request.post?
    @protect_question = params[:user][:question]
    @question = ProtectQuestion.find_by_question(@protect_question)
    @user.question_id = @question.id
    @user.save!
    self.current_user = @user
    session[:user]=self.current_user.id
    redirect_back_or_default(:controller => '/main', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    session[:user]=nil
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'main', :action => 'index')
  end
  
  def forget_pwd
    return unless request.post?
    redirect_back_or_default(:controller => 'account', :action => 'senPwdToEmail')
  end
  
  protected
  def find_user
    @questions = ProtectQuestion.find(:all)
    @question_items = Array.new
    @questions.each do |f|   
      @question_items.push(f.question)
    end 
  end
  
end
