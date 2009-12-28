class TFieldOrder < ActiveRecord::Base
  set_table_name "t_field_order"
  set_primary_key "ID"
  has_one :user_order,:class_name=>"UsersOrder",:foreign_key=>"order_id",:primary_key=>"ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
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
end
