class TFieldBadmintoonActivity < ActiveRecord::Base
  set_table_name "t_field_badmintoon_activity"
  set_primary_key "ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
  named_scope :first_field, lambda { |time_ago| { :conditions => ['created_at > ?', time_ago] }   
  
  def self.find_field(venue_id,field_type,from_time,span_time,usable_time)
    self.find_by_sql(["select * from t_field_badmintoon_activity where VENUE_ID=? and FIELD_TYPE=? and FROM_TIME>=? and FROM_TIME<? and USABLE_DATE=?",venue_id,field_type,from_time,span_time,usable_time])
  end
  
  def self.ifActivityLocked?(activity_id)
    @activity=TFieldBadmintoonActivity.find(activity_id)
    if @activity.ACTIVITY=="已预订"
      return true
    else
      return false
    end
  end
end