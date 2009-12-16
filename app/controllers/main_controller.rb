class MainController < ApplicationController
  session :session_key => '_iNeedExercise_session_id'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie  
  before_filter :get_regions_full_name
  before_filter :get_sport_type
  before_filter :set_time

  @@city_name = ""
  @@region_name = ""
  @@sport_type_name = ""
  @@venue_name = ""
  
  def index
    if request.post?
        redirect_to :controller => "search", :action => "index", :fun => "good"
    end
  end

    
  def show_cities
    @cities = City.find(:all)
    @city_names = Array.new
    @cities.each do |f|
      @city_names.push(f.name)
    end
    
    @city = City.find(:first)
    @@city_name = @city.name
    @regions_name = Array.new
    @regions = @city.regions
    @regions.each do |f|
      @regions_name.push(f.name)
    end
    
    render :partial => "show_cities"
  end
   
  def show_regions 
    @@city_name = params[:name]
    @city = City.find(:first,:conditions => {:name => @@city_name})
    @regions_name = Array.new
    @regions = @city.regions
    @regions.each do |f|
      @regions_name.push(f.name)
    end
    render :partial => "show_regions"
  end
  
  def save_selected_region
    @@region_name = params[:name]
    @local_region_name = @@region_name
    render :partial => "update_regions"
  end
  
  def show_sport_types
    @sports = SportType.find(:all)
    @sport_type_names = Array.new
    @sports.each do |f|   
      @sport_type_names.push(f.sport_type)
    end
    render :partial => "show_sport_types"
  end
  
  def save_selected_sport
    @@sport_type_name = params[:name]
    @local_sport_name = @@sport_type_name
    render :partial => "update_sports"
  end
  
  def show_all_venues
    @venues = TVenueInfo.find(:all)
    @venue_names = Array.new
    @venues.each do |f|
      @venue_names.push(f.VENUE_NAME)
    end
    render :partial => "show_all_venues"
  end
  
  def save_selected_venue
    @@venue_name = params[:name]
    @lacal_venue_name = @@venue_name
    render :partial => "update_venues"
  end
  
  def before_search
    redirect_to :controller => "search", :action => "index", :fun => "good"
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
  
  def set_time
    @time = ""
  end

end
