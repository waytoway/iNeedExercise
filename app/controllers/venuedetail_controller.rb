class VenuedetailController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :find_types
  
  #显示协议场馆
  def index
    @venue = TVenueInfo.find(params[:venue_id])
  end
  
  #显示未协议场馆信息
  def venue_info
    @venue=TVenueMemberInfo.find(:first, :conditions =>["ID=?", params[:ID]])
  end
  
  def signup
    if request.post?
      @last = TSysUser.find(:last)
      @count = @last[:ID]
      @sysuser = TSysUser.new
      @sysuser.ID = @count+1
      @sysuser.NAME = params[:user][:name]
      @sysuser.PASSWORD = params[:user][:password]
      @sysuser.PHONE = params[:user][:phone]
      @sysuser.MOBILE_PHONE = params[:user][:mobile_phone]
      @sysuser.EMAIL = params[:user][:email]
      @sysuser.CITY = params[:user][:city]
      @sysuser.DISTRICT = params[:user][:district]
      @sysuser.ADDRESS = params[:user][:address]
      @sysuser.save
      
      @ws_user = WUserToSUser.new
      @ws_user.web_user_id = session[:user]
      @ws_user.sys_user_id = @sysuser.ID
      @ws_user.save
      
      @last = TCardType.find(:last)
      @count = @last[:id]
      @cardType = TCardType.new
      @cardType.id = @count+1
      @cardType.type_name = params[:user][:type]
      @cardType.money_amount = 0
      @cardType.indate = DateTime.new(DateTime::now().year + 1,  DateTime::now().month,  DateTime::now().day)
      @cardType.save
      
      size = 1
      while size >= 1
        card_number = rand(9999999999)
        @card_temp = TMemberCard.find_by_sql(["select * from t_member_card where CARD_NUMBER = ?",card_number])
        size = @card_temp.size
      end
      @last = TMemberCard.find(:last)
      @count = @last[:ID]
      @card = TMemberCard.new
      @card.ID = @count+1
      @card.VENUE_ID = session[:venue_id]
      @card.CARD_NUMBER = card_number
      @card.NAME = params[:user][:name]
      @card.BALANCE = 0
      @card.CREATE_DATE = DateTime::now()
      @card.ID_NO = params[:user][:userid]
      @card.ADDRESS = params[:user][:address]
      @card.CARD_TYPE_ID = @cardType.id
      @card.save
      
      @user_card = UsersCard.new
      @user_card.user_id = @sysuser.ID
      @user_card.card_id = @card.ID
      @user_card.save
    else
      session[:venue_id] = params[:venue_id]
    end
  end
  
  def show_map
    redirect_to params[:url]
  end
  
  protected
  def find_types
    @type_items = Array.new
    @types = TFieldBadmintoonActivity.find_by_sql(["select distinct FIELD_TYPE from t_field_badmintoon_activity where VENUE_ID=?", params[:venue_id]])
    @types.each do |f|   
      @type_items.push(f.FIELD_TYPE)
    end
  end
end
