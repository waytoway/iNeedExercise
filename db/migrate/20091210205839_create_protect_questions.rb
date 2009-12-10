class CreateProtectQuestions < ActiveRecord::Migration
  def self.up
    create_table :protect_questions do |t|
       t.column :question,                     :string      
    end
  end

  def self.down
    drop_table :protect_questions
  end
end
