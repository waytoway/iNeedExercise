class TFieldBadmintoonActivity < ActiveRecord::Base
  set_table_name "t_field_badmintoon_activity"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  def self.find_field(venue_id,field_type,from_time,span_time,usable_time)
    self.find_by_sql(["select * from t_field_badmintoon_activity where VENUE_ID=? and FIELD_TYPE=? and FROM_TIME>=? and FROM_TIME<? and USABLE_DATE=?",venue_id,field_type,from_time,span_time,usable_time])
  end
end
