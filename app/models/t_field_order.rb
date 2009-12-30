class TFieldOrder < ActiveRecord::Base
  set_table_name "t_field_order"
  set_primary_key "ID"
  has_one :user_order,:class_name=>"UsersOrder",:foreign_key=>"order_id",:primary_key=>"ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
    
  named_scope :get_order, lambda {|id| { :conditions => ["ID=?", id]}}   
  
  def self.has_paid(order_id)
    @card=self.find(:first, :conditions =>["ID=?", order_id])
    puts @card.PAYMENT_STATUS
    return @card.PAYMENT_STATUS
  end
  
  def self.update_order(order_id)
    @card=self.find(:first, :conditions =>["ID=?", order_id])
    @card.PAYMENT_STATUS=true
    @card.save
  end
  
  #get records by month
  def self.get_records_by_month(user_id,start_page)
    @records = self.paginate_by_sql(["select VENUE_NAME,count(*) as COUNT,SUM(t_field_order.PAYMENT_SUM) as SUM  from t_field_order, users_orders, t_venue_info  where t_venue_info.ID = t_field_order.VENUE_ID  AND users_orders.order_id = t_field_order.ID AND users_orders.user_id =? and PAYMENT_STATUS=1 and YEAR(BOOK_TIME)=YEAR(NOW()) and MONTH(BOOK_TIME)=MONTH(NOW()) group by t_field_order.VENUE_ID",user_id], :page => start_page||1, :per_page => 5)    
  end
  
  def self.get_orders(user_id,start_page)
    @user_orders = self.paginate_by_sql(["select t_field_order.ID, t_field_order.field_id, t_field_order.VENUE_ID,VENUE_NAME, t_field_badmintoon.NAME, t_field_order.CARD_ID, t_field_order.USER_CODE, t_field_order.PHONE, t_field_order.PAYMENT_STATUS, t_field_order.BOOK_TIME, t_field_order.PAYMENT_TIME, t_field_order.PAYMENT_SUM, t_field_order.STANDARD_PRICE, t_field_order.PAYMENT_STYLE,t_field_badmintoon_activity.FIELD_TYPE  from t_field_order, users_orders, t_venue_info, t_field_badmintoon,t_field_badmintoon_activity  where t_field_badmintoon.ID = t_field_order.field_id AND t_venue_info.ID = t_field_order.VENUE_ID  AND users_orders.order_id = t_field_order.ID AND users_orders.user_id = ? and t_field_badmintoon_activity.ORDER_ID=t_field_order.ID", user_id], :page =>start_page||1, :per_page => 2)    
  end
end
