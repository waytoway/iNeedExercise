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
    @cards_names = []
    @cards_names[0]=["选择会员卡","选择会员卡"]
    @cards=TMemberCard.find_by_sql(["select t_member_card.CARD_NUMBER from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=? and t_member_card.BALANCE >= ?", session[:user], @venue[0].ID, params[:price]])
    i=1
    @cards.each do |f|
      @cards_names.push([f.CARD_NUMBER,f.CARD_NUMBER])
      i=i+1
    end
    
    session[:activity_id]=params[:ID]
    session[:venue_id]=params[:venue_id]
    session[:field_id]=params[:field_id]
    session[:pay_usable_date]=params[:pay_usable_date]
    session[:pay_from_time]=params[:pay_from_time]
    session[:pay_to_time]=params[:pay_to_time]
    session[:pay_from_time]=params[:pay_from_time]
    session[:price]=params[:price]
    session[:activity_id]=params[:activity_id]

  end
  
  def get_sub_items
    session[:card] = params[:card_name]
  end
  
  #创建一个订单，并且锁定activity
  def createOrder
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
    render :update do |page|
      page.redirect_to :controller=>"pay",:action=>"payment",:order_id=>@order.ID,:price=>@order.PAYMENT_SUM
      
    end
  end
  
  
  def payment
    @order_id=params[:order_id]
    @price=params[:price]
    @cards_names = []
    @cards_names[0]=["选择会员卡","选择会员卡"]
    @cards=TMemberCard.find_by_sql(["select t_member_card.CARD_NUMBER from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=? and t_member_card.BALANCE >= ?", session[:user],session[:venue_id], session[:price]])    
    i=1
    @cards.each do |f|
      @cards_names.push([f.CARD_NUMBER,f.CARD_NUMBER])
      i=i+1
    end
  end
  
  def paymentFun
    if request.post?
      #如果没有选择卡，则返回出错信息
      if params[:pay]=="card" and params[:card][:name]=="选择会员卡"
        render :js => "alert('请选择一张卡');"  
      end
      #如果选择的是99bill，则进入第三方
      if params[:pay]=="bill"
        kq_request = Kuaiqian::Request.new(@order.name, params[:order_id],
          @order.order_time,@order.price*100,'http://url/pay/show_result')
        redirect_to @request.url
      end
      #如果选择的是会员卡,并且选择的卡号正确，则进入卡支付过程
      if params[:pay]=="card" and params[:card][:name]!="选择会员卡"
        if has_card?(params[:venue_id]) && has_enough_money?(session[:venue_id],session[:price])
          @card = pay_from_card(params[:card][:name], params[:price])
          #session[:card]=nil
          if @card
            #在卡记录表里插入一条支付记录
            cardUsageRecord = TCardUsageRecord.new
            cardUsageRecord.venue_id = session[:venue_id]
            cardUsageRecord.card_id = @card.ID
            cardUsageRecord.card_no = @card.CARD_NUMBER
            cardUsageRecord.usage_date = session[:pay_usable_date]
            cardUsageRecord.usage_time_slice = session[:pay_from_time]+"-"+session[:pay_to_time]
            cardUsageRecord.option_total = session[:price]
            cardUsageRecord.usage_type = "扣款"
            cardUsageRecord.balance=@card.BALANCE
            cardUsageRecord.save
<<<<<<< HEAD
            render :text => "会员卡支付成功！"
            
            #修改activity表中ACTIVITY改为“已预定”和ORDER_ID中加入相应的order_id
            
            TFieldBadmintoonActivity.update_all(["ACTIVITY =?","已预定"], ["ID = ?", session[:activity_id]])
            
          else
            render :text => "余额不足！"
          end
        end
        
      else
        #使用第三方支付软件支付
        
        
        #如果支付成功，修改activity表中ACTIVITY改为“已预定”和ORDER_ID中加入相应的order_id
      end
      
      
      
      
=======
            render :js => "alert('会员卡支付成功！');"
          else#余额不足
            render :js => "alert('余额不足，请去个人中心充值');"            
          end
        end  
      end 
>>>>>>> 17749b2d060d5fb980d920c6a9d84a00f67641b9
    else
      render :update do |page|
        page.redirect_to :controller=>"main",:action=>"index"    
      end
    end
  end
  
  def pay_from_card(card_number, price)
    if card_has_enough_money?(card_number,price)
      @card=TMemberCard.find(:first, :conditions =>["CARD_NUMBER=?", card_number])
      new_balance=@card.BALANCE-price.to_f
      card_id=@card.ID
      #TMemberCard.find_by_sql(["UPDATE t_member_card SET BALANCE = #{new_balance} WHERE ID = #{card_id}"])
      TMemberCard.update_all(["BALANCE =?",new_balance], ["ID = ?", card_id])
      return @card
    else
      return nil
    end
  end
  
  def card_has_enough_money?(card_no, price)
    @card=TMemberCard.find_by_sql(["select * from t_member_card where CARD_NUMBER=? and t_member_card.BALANCE >= ?", card_no, price])
    @card.size > 0
  end
  
  def has_enough_money?(venue_id, price)
    #puts price
    @card=TMemberCard.find_by_sql(["select * from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=? and t_member_card.BALANCE >= ?", session[:user], venue_id, price])
    @card.size > 0
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
  
  #显示结果
  def show_result
    kq_response = Kuaiqian::Response.new(params)
    
    respond_to do |format|
      if kq_response.successful?
        render :text => '支付成功'
        #进行后续数据库操作，发送短信等等
      else
        #数据库操作
        render :text => '对不起，您提交的信息不正确'
      end
    end
  end
  protected
  def inilizeValue
    
    
  end
  
end
