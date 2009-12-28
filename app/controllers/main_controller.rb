class MainController < ApplicationController
  session :session_key => '_iNeedExercise_session_id'
  include AuthenticatedSystem
  before_filter :login_from_cookie  
  before_filter :get_regions_full_name
  before_filter :get_initial_cities
  before_filter :get_initial_regions
  before_filter :get_initial_sports
  before_filter :get_initial_popular
  
  def index
      if request.post?
        session[:city] = nil
        session[:region] = nil
        if params[:venue_name] == "输入运动场馆名称"
          redirect_to :controller => "search", :action => "index", :city_name => params[:city][:name], :region_name => params[:region][:name], 
        :sport_type_name => params[:sport][:name], :search_date => params[:search_date], :search_time => params[:time], :check_on_map => params[:map]
        else
          
          @venue = TVenueInfo.find(:first, :conditions => {:VENUE_NAME => session[:venue]})
          redirect_to :controller => "statusinfo", :action => "index", :venue_id => @venue[:ID], :from_time => params[:time], :usable_time => params[:search_date]
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
      render :text => ""
    end
    
    def show_all_venues
      @venues = TVenueInfo.find(:all, :conditions => {:city => session[:city], :district => session[:region]})
      @venue_names = Array.new
      @venues.each do |f|
        @venue_names.push(f.VENUE_NAME)
      end
      render :partial => "show_all_venues"
    end
    
    def save_selected_venue
      @lacal_venue_name = params[:name]
      render :partial => "update_venues"
    end
    
    def quit_without_save
      render :text => ""
    end
    
    def most_popular_venues
      @sport_type = params[:sport_type]
      @top10_popular_venues = TFieldOrder.find_by_sql("SELECT COUNT(*) AS NUM,t_field_badmintoon.VENUE_ID  FROM t_field_order,t_field_badmintoon WHERE t_field_order.field_id = t_field_badmintoon.ID AND t_field_badmintoon.ID IN 
    (select distinct t_field_badmintoon.ID from t_field_badmintoon_activity, t_field_badmintoon where t_field_badmintoon_activity.FIELD_ID = t_field_badmintoon.ID AND t_field_badmintoon_activity.FIELD_TYPE = '#{@sport_type}') GROUP BY t_field_badmintoon.VENUE_ID ORDER BY NUM DESC")
      @top10_popular_venue_names = []
      if @top10_popular_venues.size>0
        @top10_popular_venues.each do |f|
          @top10_popular_venue_name = TVenueInfo.find(:first, :conditions => {:ID => f[:VENUE_ID]})
          @top10_popular_venue_names.push(@top10_popular_venue_name.VENUE_NAME)
        end
      end
      render :partial => "most_popular_venues"
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
    
    def get_initial_popular
      @sport_type = "足球"
      @top10_popular_venues = TFieldOrder.find_by_sql("SELECT COUNT(*) AS NUM,t_field_badmintoon.VENUE_ID  FROM t_field_order,t_field_badmintoon WHERE t_field_order.field_id = t_field_badmintoon.ID AND t_field_badmintoon.ID IN 
    (select distinct t_field_badmintoon.ID from t_field_badmintoon_activity, t_field_badmintoon where t_field_badmintoon_activity.FIELD_ID = t_field_badmintoon.ID AND t_field_badmintoon_activity.FIELD_TYPE = '#{@sport_type}') GROUP BY t_field_badmintoon.VENUE_ID ORDER BY NUM DESC")
      @top10_popular_venue_names = []
      if @top10_popular_venues.size>0
        @top10_popular_venues.each do |f|
          @top10_popular_venue_name = TVenueInfo.find(:first, :conditions => {:ID => f[:VENUE_ID]})
          @top10_popular_venue_names.push(@top10_popular_venue_name.VENUE_NAME)
        end
      end
    end
    
  end
