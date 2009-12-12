class UsersCard < ActiveRecord::Base
  belongs_to :user,:class_name=>"User",:foreign_key=>"user_id",:primary_key=>"id"
  has_one :t_member_card,:class_name=>"TMemberCard",:foreign_key=>"ID",:primary_key=>"card_id"
end
