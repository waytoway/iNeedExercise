class MainController < ApplicationController
  session :session_key => '_iNeedExercise_session_id'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie  
  before_filter :get_regions_full_name
  before_filter :get_sport_type

  def index
    #@item = TCardType.find(:first)
    #puts @item
  end

  
  protected
  def get_regions_full_name
    @cities_and_regions = Array.new
    @cities = City.find(:all)
    @cities.each do |f|
      @city_id = f.id
      @city_name = f.name
      @regions = f.regions
      @regions.each do |g|
        @cities_and_region = @city_name + " " + g.name
        @cities_and_regions.push(@cities_and_region)
      end
    end
  end
  
  def get_sport_type
    @sports = SportType.find(:all)
    @sport_types = Array.new
    @sports.each do |f|   
      @sport_types.push(f.sport_type)
    end
  end
end
