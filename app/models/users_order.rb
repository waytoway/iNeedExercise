class UsersOrder < ActiveRecord::Base
  belongs_to :user,:class_name=>"User",:foreign_key=>"user_id",:primary_key=>"id"
  has_one :t_field_order,:class_name=>"TFieldOrder",:foreign_key=>"order_id",:primary_key=>"ID"
end
