class CreateUsersCards < ActiveRecord::Migration
  def self.up
    create_table :users_cards do |t|
      t.column :user_id,                   :integer
      t.column :card_id,                   :integer
    end
  end

  def self.down
    drop_table :users_cards
  end
end
