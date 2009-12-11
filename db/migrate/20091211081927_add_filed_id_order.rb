class AddFiledIdOrder < ActiveRecord::Migration
  def self.up
    add_column :t_field_order, :field_id, :integer
  end

  def self.down
    remove_column :t_field_order, :field_id
  end
end
