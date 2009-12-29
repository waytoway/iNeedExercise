class UserController < ApplicationController
  include UserHelper
  include AuthenticatedSystem
  before_filter :login_required
  before_filter :login_from_cookie
  before_filter :get_user
  
  def index
  end
  
  #order page
  def order_now
    @user_orders = TFieldOrder.get_orders(session[:user],params[:page])    
    render :update do |page|
      page.replace_html 'content' , :partial => 'order_now'
    end
  end
  
  #order detail page
  def order_detail
    @venue_name = params[:venue_name]
    @field_name = params[:field_name]
    @field_type = params[:field_type]
    @order = TFieldOrder.get_order(params[:order_id])[0]
    render :update do |page|
      page.replace_html 'content' , :partial => 'order_info'
    end
  end
  
  #this is the card manage loader
  def card_manage
    @cards = TMemberCard.find_all_cards(session[:user], params[:page])    
    render :update do |page|
      page.replace_html 'content' , :partial => 'card_manage'
    end
  end
  
  #this is the my records loader    
  def my_records
    @my_records = TFieldOrder.get_records_by_month(session[:user],params[:page])
    render :update do |page|
      page.replace_html 'content' , :partial => 'my_records'
    end
  end
  
  #this is the pwd loader    
  def modify_pwd
    @user = User.find(session[:user])
    @questions = ProtectQuestion.get_question_items
    render :update do |page|        
      page.replace_html 'content' , :partial => 'modify_pwd'
    end
  end
  
  #this is pwd modify action
  def modify 
    @user = User.find(session[:user])
    if request.post?
      attribute = params[:attribute]
      case attribute
        when "modify_pwd"
        if @user.correct_password?(params)
          if pass_too_short?params[:password],params[:password_confirmation]
            render :text=>"密码不能为空并且必须不少于6位"
          else
            if pass_not_equal?params[:password],params[:password_confirmation]
              render :text=>"两次密码输入不同"
            else
              @user.update_attributes(:crypted_password => @user.encrypt(params[:password]))
              render :text=>"修改成功"
            end
          end  
        else
          render :text=>"输入密码错误"   
        end
        when "pwd_protect"
        if @user.authenticated?(params[:password]) && @user.email_equal?(params[:email])
          @question = ProtectQuestion.find_by_question(params[:question])
          @user.update_attributes({:question_id => @question.id, :answer => params[:answer]})
          render :text => "修改成功"
        else
          render :text => "Email或者密码错误!"
        end
      else
        render :text=>""
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
    attribute = params[:attribute]
    case attribute
      when "modify_email"
      if params[:old_email] != @user[:email]
        render :text=>"当前邮箱信息输入错误！更新失败！"
      elsif params[:email].to_s.size < 5
        render :text=>"新邮箱输入不正确，更新失败！" 
      else
        unless @user.update_attributes!(:email => params[:email])
          render :text=>"更新失败！"
        end
        render :text=>"邮箱更新成功！" 
      end
      when "modify_cell"
      if params[:cell].to_s.size < 7
        render :text=>"新手机号输入不正确，更新失败！" 
      else
        unless @user.update_attributes!(:cell => params[:cell])
          render :text=>"更新失败！"
        end
        render :text=>"手机号更新成功！" 
      end
    end
  end
  
  #this is the user information loader    
  def user_info
    render :update do |page|        
      page.replace_html 'content' , :partial => 'user_info'
    end 
  end
  
  protected
  def get_user
    @user = User.find(session[:user])
  end
end