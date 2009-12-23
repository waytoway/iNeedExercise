class TCardUsageRecord < ActiveRecord::Base
    set_table_name "t_card_usage_record"
    set_primary_key :ID
    belongs_to :t_member_card,:class_name=>"TMemberCard",:foreign_key=>"card_id",:primary_key=>"ID"
end
