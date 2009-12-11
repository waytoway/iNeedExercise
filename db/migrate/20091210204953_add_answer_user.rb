class AddAnswerUser < ActiveRecord::Migration
  def self.up
    add_column :users, :question_id, :integer
    add_column :users, :answer, :string
  end
  
  def self.down
    remove_column :user, :question_id
    remove_column :users, :answer
    
  end
end
