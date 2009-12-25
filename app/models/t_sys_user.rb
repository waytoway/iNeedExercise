class TSysUser < ActiveRecord::Base
  set_table_name "t_sys_user"
  has_one :w_user_to_s_user,:class_name=>"WUserToSUser",:foreign_key=>"sys_user_id",:primary_key=>"ID"
  has_one :users_card,:class_name=>"UsersCard",:foreign_key=>"user_id",:primary_key=>"ID"
end
