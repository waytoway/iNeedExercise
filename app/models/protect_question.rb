class ProtectQuestion < ActiveRecord::Base
  
  #put questions to array
  def self.get_question_items
    @questions = ProtectQuestion.find(:all)
    @question_items = Array.new
    @questions.each do |f|   
      @question_items.push(f.question)
    end
    return @question_items
  end
end
