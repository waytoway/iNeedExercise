class PayController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :inilizeValue
  
  def index
    @venue = TVenueInfo.find(:all, :conditions => ["ID = ?", params[:venue_id]])
    #@@field_id = params[:field_id]
    @field = TFieldBadmintoon.find(:all, :conditions => ["ID = ?", params[:field_id]])
    @user = User.find(:all, :conditions => ["id = ?", session[:user]])
    @bookTime = params[:pay_usable_date]
    @price = params[:price]
    @authenCode = params[:authenCode]
    
    session[:activity_id]=params[:ID]
    session[:venue_id]=params[:venue_id]
    session[:field_id]=params[:field_id]
    session[:pay_usable_date]=params[:pay_usable_date]
    session[:pay_from_time]=params[:pay_from_time]
    session[:pay_to_time]=params[:pay_to_time]
    session[:pay_from_time]=params[:pay_from_time]
    session[:price]=params[:price]
  end
  
  def get_sub_items
    session[:card] = params[:card_name]
  end
  
  #创建一个订单，并且锁定activity
  def createOrder
    #查看数据是否已经被锁定
    if TFieldBadmintoonActivity.ifActivityLocked?(session[:activity_id])
      render :js => "alert('该场地已经被预定');"
    else
      @last = TFieldOrder.find(:last)
      @count = @last[:ID]
      @order = TFieldOrder.new
      @order.ID = @count+1
      @order.PAYMENT_SUM=params[:price]
      @order.field_id = session[:field_id]
      @order.VENUE_ID = session[:venue_id]
      @order.PAYMENT_STATUS = 0
      @time = Time.now
      @order.PAYMENT_TIME = @time
      @order.save!
      #锁定activity
      @activity=TFieldBadmintoonActivity.find(session[:activity_id])
      @activity.ORDER_ID=@order.ID
      @activity.ACTIVITY="已预订"
      @activity.save!
      UsersOrder.add_new(session[:user],@order.ID)
      render :update do |page|
        page.redirect_to :controller=>"pay",:action=>"payment",:order_id=>@order.ID,:price=>@order.PAYMENT_SUM,:venue_id=>@order.VENUE_ID,:type=>@activity.FIELD_TYPE
      end
    end
  end
  
  #订单入口
  def payment
    @order_id=params[:order_id]
    @price=params[:price]
    @cards_names = []
    @cards_names[0]=["选择会员卡","选择会员卡"]
    #查找用户所有该场馆该项目的卡
    @cards=TMemberCard.find_cardnumber(session[:user],params[:venue_id],params[:type])
    if @cards!=nil and @cards.size!=0
      @cards.each do |f|
        @cards_names.push([f.CARD_NUMBER,f.CARD_NUMBER])
      end
    end
  end
  
  def paymentFun
    if request.post?
      #如果order已经付钱了
      if TFieldOrder.has_paid( params[:order_id])
        render :js => "alert('请勿重复付款');"
      else
        #如果没有选择卡，则返回出错信息
        if params[:pay]=="card" and params[:card][:name]=="选择会员卡"
          render :js => "alert('请选择一张卡');"
        end
        #如果选择的是99bill，则进入第三方
        if params[:pay]=="bill"
          kq_request = Kuaiqian::Request.new("我要锻炼支付",  params[:order_id], 
          Time.now, params[:price],"http://127.0.0.1:3000/orders/show_result")
          render :update do |page|
            page.redirect_to kq_request.url              
          end
        end
        #如果选择的是会员卡,并且选择的卡号正确，则进入卡支付过程
        if params[:pay]=="card" and params[:card][:name]!="选择会员卡"
          if TMemberCard.has_enough_money?(params[:card][:name],params[:venue_id], params[:price])
            @card = TMemberCard.pay_from_card(params[:card][:name], params[:venue_id],params[:price])
            if @card
              #在卡记录表里插入一条支付记录
              
              @last = TCardUsageRecord.find(:last)
              @count = @last[:id]
              cardUsageRecord = TCardUsageRecord.new
              cardUsageRecord.id = @count+1
              cardUsageRecord.venue_id = session[:venue_id]
              cardUsageRecord.card_id = @card.ID
              cardUsageRecord.card_no = @card.CARD_NUMBER
              cardUsageRecord.usage_date = session[:pay_usable_date]
              cardUsageRecord.usage_time_slice = session[:pay_from_time]+"-"+session[:pay_to_time]
              cardUsageRecord.option_total = session[:price]
              cardUsageRecord.usage_type = "扣款"
              cardUsageRecord.balance=@card.BALANCE
              cardUsageRecord.save
              #更新order记录
              TFieldOrder.update_order(params[:order_id])
              #进行后续操作，发送短信等等              
              render :js => "alert('会员卡支付成功！');"
            else
              render :js => "alert('会员卡支付失败！');"
            end
          else#余额不足
            render :js => "alert('余额不足，请去个人中心充值');"
          end
        end
      end
    else
      render :update do |page|
        page.redirect_to :controller=>"main",:action=>"index"
      end
    end
  end
  
  def has_card?(venue_id)
    @card=TMemberCard.find_by_sql(["select * from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=?", session[:user], venue_id])
    @card.size > 0
  end
  
  #充值
  def supplement
    @card_number=params[:card_number]
    @amount=params[:amount]
    
  end
  
  def supplement_commit
    kq_request = Kuaiqian::Request.new("我要锻炼支付",  params[:order_id], 
    Time.now, params[:price],"http://127.0.0.1:3000/orders/show_supplement_result")
    render :update do |page|
      page.redirect_to kq_request.url              
    end
  end
  
  def show_supplement_result
    kq_response = Kuaiqian::Response.new(params)
    respond_to do |format|
      if kq_response.successful?
        TFieldOrder.update_order(params[:order_id])     
        #进行后续操作，发送短信等等        
        render :text => '支付成功'
      else
        render :text => '对不起，您提交的信息不正确'
      end
    end
  end
  
  #显示结果
  def show_result
    kq_response = Kuaiqian::Response.new(params)
    
    respond_to do |format|
      if kq_response.successful?
        TFieldOrder.update_order(params[:order_id])     
        #进行后续操作，发送短信等等        
        render :text => '支付成功'
      else
        render :text => '对不起，您提交的信息不正确'
      end
    end
  end
  
  protected
  def inilizeValue
    
    
  end
  
end
