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
    
    session[:venue_id]=params[:venue_id]
    session[:field_id]=params[:field_id]
    session[:pay_usable_date]=params[:pay_usable_date]
    session[:pay_from_time]=params[:pay_from_time]
    session[:pay_to_time]=params[:pay_to_time]
    session[:pay_from_time]=params[:pay_from_time]
    session[:price]=params[:price]
    
    i=1
    @cards.each do |f|
      @cards_names.push([f.CARD_NUMBER,f.CARD_NUMBER])
      i=i+1
    end
  end
  
  def get_sub_items
    session[:card] = params[:card_name]
  end
  
  def createOrder
    @orders = TFieldOrder.find(:all)
    @count = @orders.size
    @order = TFieldOrder.new
    @order.ID = @count+1
    @order.field_id = session[:field_id]
    @order.VENUE_ID = session[:venue_id]
    @order.PAYMENT_STATUS = 0
    @time = Time.now
    @order.PAYMENT_TIME = @time
    @order.save!
    puts "create Order"
    render :text=>"create Order"
  end
  
  def paymentFun
    if request.post?
      if has_card?(params[:venue_id]) && has_enough_money?(session[:venue_id],session[:price])
       
        #使用该场馆的会员卡支付
        if params[:card][:name]=="选择会员卡"
          render :text => "请选择会员卡！"
        else
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
            
            render :text => "会员卡支付成功！"
          else
            puts "余额不足！"
          end
        end
        
      else
        #使用第三方支付软件支付
        
      end
      
      #修改activity表中ACTIVITY改为“已预定”和ORDER_ID中加入相应的order_id
      
      
    else
      
    end
  end
  
  def pay_from_card(card_number, price)
    if has_enough_money?(session[:venue_id],session[:price])
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
  
  def has_enough_money?(venue_id, price)
    #puts price
    @card=TMemberCard.find_by_sql(["select * from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=? and t_member_card.BALANCE >= ?", session[:user], venue_id, price])
  end
  
  def has_card?(venue_id)
    @card=TMemberCard.find_by_sql(["select * from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=?", session[:user], venue_id])
    @card.size > 0
  end
  
  def orderInfo
    #puts params[:venue_id]
    #puts params[:field_id]
    #puts params[:period]
    #puts params[:price]
    #puts params[:usable]
    #puts params[:usable_date]
    #puts params[:authenCode]
    #puts "In pay function controller"
    
  end
  
  #充值
  def supplement
    @card_number=params[:card_number]
    @amount=params[:amount]
    
  end
  
  protected
  def inilizeValue
    
    
  end
  
end
