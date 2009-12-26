class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title,                     :string
      t.column :content,                   :longtext
      t.column :parent_id,                 :integer
    end
  end

  def self.down
    drop_table :pages
  end
end
