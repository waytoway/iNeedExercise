class TFieldBadmintoonActivity < ActiveRecord::Base
  set_table_name "t_field_badmintoon_activity"
  set_primary_key "ID"
  belongs_to :t_venue_info,:class_name=>"TVenueInfo",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
  named_scope :one_hour_fields, lambda { |venue_id,sport_name,search_date,search_time,next_hour| { :conditions => ['VENUE_ID = ? and FIELD_TYPE = ? and USABLE_DATE = ? and FROM_TIME >= ? and FROM_TIME < ?',venue_id, sport_name, search_date, search_time, next_hour ] }}   
  named_scope :all_inactivicy_fields, lambda { |venue_id,sport_name,search_date,search_time,next_hour| { :conditions => ['VENUE_ID = ? and FIELD_TYPE = ? and USABLE_DATE = ? and FROM_TIME >= ? and FROM_TIME < ? and ACTIVITY = ?',venue_id, sport_name, search_date, search_time, next_hour, '未预订' ] }}
  
  def self.find_field(venue_id,field_type,from_time,span_time,usable_time)
    self.find_by_sql(["select * from t_field_badmintoon_activity where VENUE_ID=? and FIELD_TYPE=? and FROM_TIME>=? and FROM_TIME<? and USABLE_DATE=?",venue_id,field_type,from_time,span_time,usable_time])
  end
  
  #是否已经被别人锁定？
  def self.ifActivityLocked?(activity_id)
    @activity=TFieldBadmintoonActivity.find(activity_id)
    if @activity.ACTIVITY=="已预订"
      return true
    else
      return false
    end
  end
  
  #修改成为未预订
  def self.reset_to_unordered(order_id)
    @activity=self.find(:first, :conditions =>["ORDER_ID=?", order_id])
    @activity.update_attributes!(:ACTIVITY => "未预订",:ORDER_ID=>nil)
  end
end