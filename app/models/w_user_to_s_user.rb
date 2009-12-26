class WUserToSUser < ActiveRecord::Base
  belongs_to :user,:class_name=>"User",:foreign_key=>"web_user_id",:primary_key=>"id"
  belongs_to :t_sys_user,:class_name=>"TSysUser",:foreign_key=>"sys_user_id",:primary_key=>"ID"
end
