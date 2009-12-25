class UsersOrder < ActiveRecord::Base
  belongs_to :user,:class_name=>"User",:foreign_key=>"user_id",:primary_key=>"id"
  belongs_to :t_field_order,:class_name=>"TFieldOrder",:foreign_key=>"order_id",:primary_key=>"ID"
  
  def self.add_new(user_id,order_id)
    @user_order = UsersOrder.new
    @user_order.user_id = user_id
    @user_order.order_id = order_id
    @user_order.save
  end
end
