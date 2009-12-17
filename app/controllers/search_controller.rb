class SearchController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :get_user_cards
  before_filter :get_initial_and_regions

  def index
    @cities = City.find(:all)
    @city_names = Array.new
    @city_names.push("选择城市")
    @cities.each do |f|
      @city_names.push(f.name)
    end

    puts "ccccccccccccccccccc"
    puts @city_names
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
    puts "bbbbbbbbbbbbbbbb"
    puts @users_cards.size
    puts @page_count
  end
  
  def get_initial_and_regions
    @regions_name = Array.new
    @regions_name.push("选择区域")
  end
  
end
