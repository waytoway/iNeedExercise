class TMemberCard < ActiveRecord::Base
  set_table_name "t_member_card"
  set_primary_key "ID"
  has_one :users_card,:class_name=>"UsersCard",:foreign_key=>"card_id",:primary_key=>"ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_weekend_price, :class_name=>"TFieldBadmintoonWeekendPrice",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
  
  def self.find_cardnumber(user_id,venue_id,type)
    @cards=self.find_by_sql(["select t_member_card.CARD_NUMBER from users,w_user_to_s_users,t_sys_user,users_cards,t_member_card,t_card_type where users.id=? and users.id=w_user_to_s_users.web_user_id and w_user_to_s_users.sys_user_id=t_sys_user.ID and t_sys_user.ID=users_cards.user_id and users_cards.card_id=t_member_card.ID and t_member_card.VENUE_ID=? and t_member_card.CARD_TYPE_ID=t_card_type.id and t_card_type.type_name=?", user_id,venue_id,type]) 
  end
  
  def self.has_enough_money?(card_number,venue_id, price)
    @card=self.find_by_sql(["select * from t_member_card where CARD_NUMBER=? and VENUE_ID=? and BALANCE>=?", card_number,venue_id, price])
    if @card!=nil && @card.size!=0
      return true
    else
      return false
    end
  end
  
  def self.pay_from_card(card_number, venue_id,price)
    @card=self.find(:first, :conditions =>["CARD_NUMBER=? and VENUE_ID=?", card_number,venue_id])
    new_balance=@card.BALANCE-price.to_f
    card_id=@card.ID
    #TMemberCard.find_by_sql(["UPDATE t_member_card SET BALANCE = #{new_balance} WHERE ID = #{card_id}"])
    TMemberCard.update_all(["BALANCE =?",new_balance], ["ID = ?", card_id])
    return @card
  end
end
