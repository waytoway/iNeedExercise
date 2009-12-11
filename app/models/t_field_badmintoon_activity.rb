class TFieldBadmintoonActivity < ActiveRecord::Base
  set_table_name "t_field_badmintoon_activity"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
end
