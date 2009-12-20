class MainController < ApplicationController
  session :session_key => '_iNeedExercise_session_id'
  include AuthenticatedSystem
  before_filter :login_from_cookie  
  before_filter :get_regions_full_name
  before_filter :get_initial_cities
  before_filter :get_initial_regions
  before_filter :get_initial_sports
  
  def index
    if request.post?
      session[:city] = params[:city][:name]
      session[:sport] = params[:sport][:name]
      session[:search_date] = params[:search_date]
      session[:search_time] = params[:time]
      session[:check_on_map] =params[:map]
      if session[:venue] == nil
        redirect_to :controller => "search", :action => "index", :city_name => params[:city][:name], :region_name => session[:region_name], 
        :sport_type_name => params[:sport][:name], :venue_name => session[:venue], :search_date => session[:search_date]
      else
        session[:venue] = nil
        redirect_to :controller => "statusinfo", :action => "index"
      end
    end
  end
  
  def get_sub_items   
    session[:city] = params[:city_name]
    session[:region] = "选择区域"
    if session[:city] == "选择城市"
      @regions_name = []
      @regions_name[0] = ["选择区域","选择区域"]
    else
      @city = City.find(:first,:conditions => {:name => session[:city]})
      @regions_name = []
      @regions = @city.regions
      @regions_name[0] = ["选择区域","选择区域"]
      i=1
      @regions.each do |f|
        @regions_name.push([f.name,f.name])
        i=i+1
      end 
    end
    
    render :partial => "select"
  end
  
  def jump_for_sub_item
    session[:region] = params[:region_name]
    puts session[:region]
    render :text => ""
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
    session[:venue] = params[:name]
    puts "aaaaaaaaaaaaaaa"
    puts session[:venue]
    @lacal_venue_name = session[:venue]
    render :partial => "update_venues"
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
  
  def get_initial_cities
    @cities = City.find(:all)
    @city_names = Array.new
    @city_names.push("选择城市")
    @cities.each do |f|
      @city_names.push(f.name)
    end
  end
  
  def get_initial_regions
    @regions_name = Array.new
    @regions_name.push("选择区域")
  end
  
  def get_initial_sports
    @sports = SportType.find(:all)
    @sport_type_names = Array.new
    @sport_type_names.push("运动项目")
    @sports.each do |f|   
      @sport_type_names.push(f.sport_type)
    end
  end
  
end
