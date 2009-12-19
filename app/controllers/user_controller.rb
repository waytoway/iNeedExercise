class UserController < ApplicationController
  before_filter :login_required
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_user
  
  def index
  end
  
  def paymentFun
    #puts params[:venue_name]
    render :update do |page|
      page.replace_html 'content' , :partial => 'payment'
    end
  end
  
  def order_detail
    #puts params[:order_id]
    #puts params[:venue_name]
    #puts params[:field_name]
    @venue_name = params[:venue_name]
    @field_name = params[:field_name]
    @order = TFieldOrder.find(:all, :conditions=>["ID=?", params[:order_id]])
    #puts @order.size
    render :update do |page|
      page.replace_html 'content' , :partial => 'order_info'
    end
  end
  
  def order_now
    @user_orders = TFieldOrder.paginate_by_sql([%!select t_field_order.ID, t_field_order.field_id, VENUE_NAME, t_field_badmintoon.NAME, t_field_order.CARD_ID, t_field_order.USER_CODE, t_field_order.PHONE, t_field_order.PAYMENT_STATUS, t_field_order.BOOK_TIME, t_field_order.PAYMENT_TIME, t_field_order.PAYMENT_SUM, t_field_order.STANDARD_PRICE, t_field_order.PAYMENT_STYLE  from t_field_order, users_orders, t_venue_info, t_field_badmintoon  where t_field_badmintoon.ID = t_field_order.field_id AND t_venue_info.ID = t_field_order.VENUE_ID  AND users_orders.order_id = t_field_order.ID AND users_orders.user_id = #{session[:user]}!, true], :page => params[:page]||1, :per_page => 2)
    #puts @user_orders.size
    #puts @user_orders[0][:VENUE_NAME]
    #puts @user_orders[0][:NAME]
    #@orderIDs = TMemberCard.find(:all, :conditions => ["VENUE_ID = 1"])
    #puts @orderIDs.size
    #@user_orders = @orderIDs.paginate(:page => params[:page]||1, :per_page => 2)
    #@orders = TFieldOrder.find(:all, :conditions => ["ID = 1"])  
    #@user_orders = UsersOrder.paginate :include => [:t_field_order], :page => params[:page]||1, :per_page => 2,:conditions=>"user_id=#{session[:user]}"
    #puts @user_orders.size
    
    #@user_orders = UsersOrder.paginate :page => params[:page]||1, :per_page => 2,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|
      page.replace_html 'content' , :partial => 'order_now'
    end
  end
  
  #this is the card manage loader
  def card_manage
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 2,:conditions=>"user_id=#{session[:user]}"
    
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.js do
    render :update do |page|
      page.replace_html 'content' , :partial => 'card_manage'
    end
  end
  #    end
  #  end 
  
  #this is the my records loader    
  def my_records
    render :update do |page|        
      page.replace_html 'content' , :partial => 'my_records'
    end
  end
  
  #this is the order now loader      
  #def order_now
  #render :update do |page|        
  #page.replace_html 'content' , :partial => 'order_now'
  #end
  #end
  
  #def modify_order_now
  
  #end
  
  #this is the pwd  loader    
  def modify_pwd
    @user = User.find(session[:user])
    #@questions = ["where is your home?","what is your first teacher name?"]
    @questions = ProtectQuestion.find(:all)
    @question_items = Array.new
    @questions.each do |f|   
      @question_items.push(f.question)
    end 
    render :update do |page|        
      page.replace_html 'content' , :partial => 'modify_pwd'
    end
  end
  
  def modify 
    @user = User.find(session[:user])
    if request.post?
      attribute = params[:attribute]
      case attribute
        when "modify_pwd"
        if @user.correct_password?(params)
          if params[:password] != params[:password_confirmation]
            render :text=>"两次密码输入不同"
          else
            @user.update_attributes(:crypted_password => @user.encrypt(params[:password]))
            render :text=>"修改成功"
          end
        else
          render :text=>"输入密码错误"
        end
        when "pwd_protect"
        if @user.authenticated?(params[:password]) && @user.email_equal?(params[:email])
          @protect_question = params[:question]
          @question = ProtectQuestion.find_by_question(@protect_question)
          @user.update_attributes({:question_id => @question.id, :answer => params[:answer]})
          render :text => "成功发送"
        else
          render :text => "Email或者密码错误!"
        end
      else
        render :text=>"无修改"
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
    if params[:email]=="" || params[:email].to_s.size < 3 || params[:cell]=="" || params[:cell].to_s.size < 7
      render :text=>"新邮箱或手机号输入不正确，更新失败！" 
      #redirect_to :action => "index"
    else
      unless @user.update_attributes!(:email => params[:email])
        render :text=>"too short"
      end
      unless @user.update_attributes!(:cell => params[:cell])
        render :text=>"too short"
      end
      render :text=>"邮箱和手机号更新成功！" 
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
    #@questions = ["where is your home?","what is your first teacher name?"]
    @questions = ProtectQuestion.find(:all)
    @question_items = Array.new
    @questions.each do |f|   
      @question_items.push(f.question)
    end 
  end
end
