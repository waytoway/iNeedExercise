class AddUrlToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :url, :string
    add_column :pages, :is_admin, :boolean
    add_column :pages, :is_login, :boolean
  end

  def self.down
    remove_column :pages, :url
    remove_column :pages, :is_admin
    remove_column :pages, :is_login
  end
end
