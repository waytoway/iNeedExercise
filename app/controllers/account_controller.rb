class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie 
  before_filter :find_user
  
  # say something nice, you goof!  something sweet.
  def index
    #redirect_to(:action => 'signup') unless logged_in? || User.count > 0

  end
  
  
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    @tmp_user = session[:user]
    puts "ddddddddddddddddddddddd"
    puts @tmp_user
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
    #  redirect_to request.request_uri
      redirect_to(:controller => 'account', :action => 'login')
    end
  end
  
  def signup
    if logged_in?
      logout
    end
    @user = User.new(params[:user])
    return unless request.post?
    puts "jin ru sign up"
    @protect_question = params[:user][:question]
    @question = ProtectQuestion.find_by_question(@protect_question)
    @user.question_id = @question.id
    @user.save!
    self.current_user = @user
    session[:user]=self.current_user.id
    redirect_back_or_default(:controller => '/account', :action => 'index')
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
