class SearchController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_user_cards
  before_filter :get_initial_cities
  before_filter :get_initial_regions
  before_filter :get_initial_sports
  
  def index
    if request.post?
      session[:city] = params[:city][:name]
      session[:region] = params[:region][:name]
      session[:sport] = params[:sport][:name]
      session[:search_date] = params[:search_date]
      session[:search_time] = params[:time]
    end    
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @venues = TFieldOrder.paginate_by_sql([%!SELECT DISTINCT t_venue_info.ID, t_venue_info.VENUE_NAME FROM t_field_badmintoon_activity, t_venue_info WHERE t_field_badmintoon_activity.FIELD_TYPE="#{session[:sport]}" AND t_field_badmintoon_activity.FROM_TIME='07:00' AND t_field_badmintoon_activity.VENUE_ID=t_venue_info.ID AND t_venue_info.CITY="#{session[:city]}" AND t_venue_info.DISTRICT='#{session[:region]}'!, true], :page => params[:page]||1, :per_page => 2)
    
    @show_records = []
    @venues.each do |f|
      puts f[:VENUE_NAME]
      @fields = TFieldBadmintoonActivity.find(:all, :conditions => {:VENUE_ID => f[:ID], :FIELD_TYPE => "羽毛球", :FROM_TIME => "07:00"})
      if @fields.size > 0
        @venue_state = "已预定"
        @min_price
        @max_price
        @price
        @index = 0
        @fields.each do |g|
          if g.ACTIVITY = "未预定"
            @venue_state = "未预定"
          end
          if(@index == 0)
            @min_price = g.PRICE
            @max_price = g.PRICE
          else
            if g.PRICE > @max_price
              @max_price = g.PRICE
            end
            if g.PRICE < @max_price
              @max_price = g.PRICE
            end
          end
          @index = @index+1
        end
        puts @min_price
        puts @max_price
        if @min_price < @max_price
          @price = "#{@min_price}-#{@max_price}"
        else
          @price = "#{@min_price}"
        end
        @show_records.push([session[:search_date],@price,@venue_state])
      end
    end
    
    @users_cards2 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"
    @users_cards3 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"
    
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
    session[:region] = params[:region]
    render :text => ""
  end
  
  def detail
    
  end
  
  def recommend
    
  end
  
  def card_manage
    puts "jin ru card_manage"
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 2,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|
      page.replace_html 'content' , :partial => 'card_manage'
    end
  end
  
  def negotiated_venues
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|
      page.replace_html 'table1' , :partial => 'negotiated_venues'
    end
  end
  
  def unnegotiated_venues
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|
      page.replace_html 'table2' , :partial => 'unnegotiated_venues'
    end
  end
  
  def other_venue_in_the_region
    @users_cards = UsersCard.paginate :page => params[:page]||1, :per_page => 6,:conditions=>"user_id=#{session[:user]}"
    render :update do |page|
      page.replace_html 'table3' , :partial => 'other_venue_in_the_region'
    end
  end
  
  protected
  def get_user_cards
  end
  
  def get_initial_cities
    @cities = City.find(:all)
    @city_names = []
    @city_names[0]=["选择城市","选择城市"]
    i=1
    @cities.each do |f|
      @city_names.push([f.name,f.name])
      i=i+1
    end
  end
  
  def get_initial_regions
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
  end
  
  def get_initial_sports
    @sports = SportType.find(:all)
    @sport_type_names = []
    @sport_type_names[0]=["运动项目","运动项目"]
    i=1
    @sports.each do |f|   
      @sport_type_names.push([f.sport_type,f.sport_type])
      i=i+1
    end
  end
  
end
