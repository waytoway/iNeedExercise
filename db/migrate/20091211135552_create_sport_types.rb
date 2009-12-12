class CreateSportTypes < ActiveRecord::Migration
  def self.up
    create_table :sport_types do |t|
      t.column :sport_type,                :string
    end
  end

  def self.down
    drop_table :sport_types
  end
end
