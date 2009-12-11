class TMemberCard < ActiveRecord::Base
  set_table_name "t_member_card"
  belongs_to :user,:class_name=>"User",:foreign_key=>"NAME",:primary_key=>"login"
  has_many :t_card_usage_records,:class_name=>"TCardUsageRecord",:foreign_key=>"card_id",:primary_key=>"ID"
end
