class CreateUsersOrders < ActiveRecord::Migration
  def self.up
    create_table :users_orders do |t|
      t.column :user_id,                   :integer
      t.column :order_id,                  :integer
    end
  end

  def self.down
    drop_table :users_orders
  end
end
