class TFieldOrder < ActiveRecord::Base
  set_table_name "t_field_order"
  has_one :user_order,:class_name=>"UsersOrder",:foreign_key=>"order_id",:primary_key=>"ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
end
