class SearchController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :get_user_cards
  before_filter :get_initial_cities
  before_filter :get_initial_regions
  before_filter :get_initial_sports

  def index
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    @users_cards2 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"
    @users_cards3 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"

  end  
     
  def get_sub_items   
    session[:city_name] = params[:city_name]
    @city = City.find(:first,:conditions => {:name => session[:city_name]})
    @regions_name = Array.new
    @regions = @city.regions
    @regions_name.push("选择区域")
    @regions.each do |f|
      @regions_name.push(f.name)
    end 
       
    render :partial => "select"   
  end 
  
  def jump_for_sub_item
    session[:region_name] = params[:region_name]
    render :text => ""
  end
  
  def detail
    
  end
  
  def recommend
    
  end
  
  def negotiated_venues
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.js do
    render :update do |page|
      page.replace_html 'table1' , :partial => 'negotiated_venues'
    end
  end
  
  def unnegotiated_venues
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.js do
    render :update do |page|
      page.replace_html 'table2' , :partial => 'unnegotiated_venues'
    end
  end
  
  def other_venue_in_the_region
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.js do
    render :update do |page|
      page.replace_html 'table3' , :partial => 'other_venue_in_the_region'
    end
  end
  
  protected
  def get_user_cards
    @users_cards = UsersCard.find(:all, :conditions => {:user_id => session[:user]})
    @page_count = @users_cards.size/6
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
