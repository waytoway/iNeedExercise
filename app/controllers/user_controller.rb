class UserController < ApplicationController
  before_filter :login_required
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :find_user
  
  def index
  end
  
  #this is the card manage loader
  def card_manage
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 2,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|        
      page.replace_html 'content' , :partial => 'card_manage'
    end
  end 
  
  #this is the my records loader    
  def my_records
    render :update do |page|        
      page.replace_html 'content' , :partial => 'my_records'
    end
  end
  
  #this is the order now loader      
  def order_now
    render :update do |page|        
      page.replace_html 'content' , :partial => 'order_now'
    end
  end
  
  def modify_order_now
    
  end
  
  #this is the pwd  loader    
  def modify_pwd
    render :update do |page|        
      page.replace_html 'content' , :partial => 'modify_pwd'
    end
  end
  
  def modify  
    @user = User.find(session[:user])
    puts @user.email
    if request.post?
      attribute = params[:attribute]
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
          @protect_question = params[:user][:question]
          puts @protect_question
          @question = ProtectQuestion.find_by_question(@protect_question)
          puts @question
          @user.update_attributes({:question_id => @question.id, :answer => params[:user][:answer]})
          
          redirect_to :action => "index"
        else
          flash[:notice] = "Email or password is wrong!"
          redirect_to :action => "index"
        end
      end
    end
    @user.clear_password!
  end
  
  #this is the login information loader    
  def login_infor
    render :update do |page|        
      page.replace_html 'content' , :partial => 'login_infor'
    end 
  end
  
  def modify_login_infor
    render :text=>"" unless request.post?
    unless @user.update_attributes!(:email => params[:email])
      render :text=>"too short"
    end
    unless @user.update_attributes!(:cell => params[:cell])
      render :text=>"tooooo short"
    end
    render :text=>"success" 
  end
  
  #this is the user information loader    
  def user_info
    render :update do |page|        
      page.replace_html 'content' , :partial => 'user_info'
    end 
  end
  
  protected
  def find_user
    @user = User.find(session[:user])
    #@questions = ["where is your home?","what is your first teacher name?"]
    @questions = ProtectQuestion.find(:all)
    @question_items = Array.new
    @questions.each do |f|   
      @question_items.push(f.question)
    end 
  end
end
