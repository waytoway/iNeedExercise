class TMemberCard < ActiveRecord::Base
  set_table_name "t_member_card"
  has_one :users_card,:class_name=>"UsersCard",:foreign_key=>"card_id",:primary_key=>"ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_weekend_price, :class_name=>"TFieldBadmintoonWeekendPrice",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
end
