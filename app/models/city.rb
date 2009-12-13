class City < ActiveRecord::Base
  has_many :regions
  
    
  attr_accessor :city_and_region_name
  
end
