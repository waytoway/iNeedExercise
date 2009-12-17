class TVenueInfo < ActiveRecord::Base
  set_table_name "t_venue_info"
  
  has_many :t_field_badmintoon, :class_name=>"TFieldBadmintoon",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_activity, :class_name=>"TFieldBadmintoonActivity",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_basic_price, :class_name=>"TFieldBadmintoonBasicPrice",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_special_price, :class_name=>"TFieldBadmintoonSpecialPrice",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  has_many :t_field_badmintoon_weekend_price, :class_name=>"TFieldBadmintoonWeekendPrice",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
  has_many :t_field_order, :class_name=>"TFieldOrder",:foreign_key=>"VENUE_ID",:primary_key=>"ID"
  
end
