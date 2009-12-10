class UserController < ApplicationController
  before_filter :login_required
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :find_user
  
  def index
    #redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    
  end

  def modify_pwd
    
  end
    
  def modify  
    @user = User.find(session[:user_id])
    puts @user.email
    if request.post?
      attribute = params[:attribute]
      puts "aaaaaaaaaaaaaaaaaaaaaaaaaa"
      puts attribute
      puts params
      case attribute
      when "modify_pwd"
        if @user.correct_password?(params)
          unless params[:user][:password] == params[:user][:password_confirmation]
            @user.password_errors(params) 
            return
          end
          @user.update_attributes(:crypted_password => @user.encrypt(params[:user][:password]))
          redirect_to :action => "index"
        else
          @user.password_errors(params)
        end
      when "pwd_protect"
        if @user.authenticated?(params[:user][:password]) && @user.email_equal?(params[:user][:email])
          puts "jin ru xiu gai mi ma mo kuai"
          #@user.update_attributes!(:crypted_password => @user.encrypt(params[:user][:password]))
          @protect_question = params[:user][:question]
          @question = Question.find(:first, :conditions => "question = '#{protect_question}'")
          @user.update_attributes({:question_id => @question.id, :answer => params[:user][:answer]})

          redirect_to :action => "index"
        else
          puts "mi ma chu cuo"
          #@user.update_attributes!(:crypted_password => @user.encrypt(params[:user][:password]))
          redirect_to :action => "index"
        end
      end
    end
    @user.clear_password!
  end

  def login_infor
    return unless request.post?
        puts params[:user][:email]
        unless @user.update_attributes!(:email => params[:user][:email])
          flash[:notice] = "Email can't be blank or is too short!"
        end
        unless @user.update_attributes!(:cell => params[:user][:cell])
          flash[:notice] = "Cell can't be blank or is too short!"
        end
        redirect_to :action => "index"
  end
  
  protected
  def find_user
    @user = User.find(session[:user_id])
    @questions = ["你的家乡在哪里？","你的第一位老师的名字？"]
  end
end
