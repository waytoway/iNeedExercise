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
      @bookTime = params[:usable_date]
      @price = params[:price]
      @authenCode = params[:authenCode]
      
      @cards_names = []
      @cards_names[0]=["选择会员卡","选择会员卡"]
      @cards=TMemberCard.find_by_sql(["select t_member_card.CARD_NUMBER from users_cards, t_member_card where users_cards.card_id=t_member_card.ID and users_cards.user_id=? and t_member_card.VENUE_ID=?", session[:user], @venue[0].ID])
      
      i=1
      @cards.each do |f|
        @cards_names.push([f.CARD_NUMBER,f.CARD_NUMBER])
        i=i+1
      end
  end
  
  def get_sub_items
    puts "get sub items"
    session[:card] = params[:card_name]
  end
    
  def paymentFun
    if request.post?
      #puts params[:venue_name]
      #puts params[:venue_id]
      #puts params[:card_name]
      puts "andy"
      puts params[:card]
      puts params[:card_name]
      puts session[:card]
      if has_card?(params[:venue_id]) && has_enough_money?(params[:venue_id],params[:price])
        #使用该场馆的会员卡支付
        puts "has card" 
      else
        #使用第三方支付软件支付
        #end
      end
      
      render :update do |page|
        page.replace_html 'content' , :partial => 'payment'
      end
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
  
  protected
  def inilizeValue
    
      
  end
    
end
