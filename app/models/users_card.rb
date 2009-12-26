class UsersCard < ActiveRecord::Base
  belongs_to :t_sys_user,:class_name=>"TSysUser",:foreign_key=>"user_id",:primary_key=>"ID"
  belongs_to :t_member_card,:class_name=>"TMemberCard",:foreign_key=>"card_id",:primary_key=>"ID"
end
