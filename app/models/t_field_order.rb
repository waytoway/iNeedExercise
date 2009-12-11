class TFieldOrder < ActiveRecord::Base
  set_table_name "t_field_order"
  has_one :user_order,:class_name=>"UsersOrder",:foreign_key=>"order_id",:primary_key=>"ID"
end
