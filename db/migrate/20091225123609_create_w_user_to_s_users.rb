class CreateWUserToSUsers < ActiveRecord::Migration
  def self.up
    create_table :w_user_to_s_users do |t|
      t.column :web_user_id,                   :integer
      t.column :sys_user_id,                   :integer
    end
  end

  def self.down
    drop_table :w_user_to_s_users
  end
end
