class TCardUsageRecord < ActiveRecord::Base
  set_table_name "t_card_usage_record"
    belongs_to :t_member_card,:class_name=>"TMemberCard",:foreign_key=>"card_id",:primary_key=>"ID"
end
