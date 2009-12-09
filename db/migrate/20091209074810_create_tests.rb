class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.column :email,                     :string
    end
  end

  def self.down
    drop_table :tests
  end
end
