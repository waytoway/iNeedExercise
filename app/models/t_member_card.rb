class TMemberCard < ActiveRecord::Base
  set_table_name "t_member_card"
  has_one :users_card,:class_name=>"UsersCard",:foreign_key=>"ID",:primary_key=>"card_id"
end
