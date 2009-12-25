class SearchController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_user_cards
  before_filter :get_initial_cities
  before_filter :get_initial_regions
  before_filter :get_initial_sports
  
  def index
    if request.post?
      Payover.deliver_notifyUser("caijia","caijiaddk@sina.com")
      session[:city] = params[:city][:name]
      session[:region] = params[:region][:name]
      session[:sport] = params[:sport][:name]
      session[:search_date] = params[:search_date]
      session[:search_time] = params[:time]
    end    
    #  @photos = Photo.paginate(:all, :conditions => ["photos.user_id = ?", current_user.id], :page => params[:page])
    @cur_time=Time.parse session[:search_time]
    @next_hour_time = @cur_time+3600
    @next_two_hour_time = @cur_time+7200
    @next_three_hour_time = @cur_time+10800
    @next_hour = @next_hour_time.strftime("%H:%M").to_s
    @next_two_hour = @next_two_hour_time.strftime("%H:%M").to_s
    @next_three_hour = @next_three_hour_time.strftime("%H:%M").to_s
    
    @venues = TFieldOrder.paginate_by_sql([%!SELECT DISTINCT t_venue_info.ID, t_venue_info.VENUE_NAME FROM t_field_badmintoon_activity, t_venue_info WHERE t_field_badmintoon_activity.FIELD_TYPE="#{session[:sport]}" AND t_field_badmintoon_activity.FROM_TIME>='#{session[:search_time]}' AND t_field_badmintoon_activity.FROM_TIME<'#{@next_three_hour}' AND t_field_badmintoon_activity.VENUE_ID=t_venue_info.ID AND t_field_badmintoon_activity.USABLE_DATE='#{session[:search_date]}' AND t_venue_info.CITY="#{session[:city]}" AND t_venue_info.DISTRICT='#{session[:region]}' AND t_field_badmintoon_activity.ACTIVITY='未预定'!, true], :page => params[:page]||1, :per_page => 7)
    
    #mei zuo fei ling pan duan
    @show_records = []
    @venues.each do |f|
      @min_price
      @max_price
      @price
      
      @venue_state_1 = "已预订"
      @venue_state_2 = "已预订"
      @venue_state_3 = "已预订"
      
      @fields_1 = TFieldBadmintoonActivity.find_by_sql("SELECT t.ID,t.PRICE,t.ACTIVITY FROM `exercise-test`.t_field_badmintoon_activity t WHERE t.VENUE_ID='#{f[:ID]}' AND t.FIELD_TYPE='#{session[:sport]}' AND t.FROM_TIME>='#{session[:search_time]}' AND t.FROM_TIME<'#{@next_hour}'")
      if @fields_1.size > 0
        
        @index = 0
        @fields_1.each do |g|
          if g.ACTIVITY == "未预定"
            @venue_state_1 = "未预定"
          end
          if(@index == 0)
            @min_price_1 = g.PRICE
            @max_price_1 = g.PRICE
          else
            if g.PRICE > @max_price_1
              @max_price_1 = g.PRICE
            end
            if g.PRICE < @min_price_1
              @min_price_1 = g.PRICE
            end
          end
          @index = @index+1
        end
      end
      
      @fields_2 = TFieldBadmintoonActivity.find_by_sql("SELECT t.ID,t.PRICE,t.ACTIVITY FROM `exercise-test`.t_field_badmintoon_activity t WHERE t.VENUE_ID='#{f[:ID]}' AND t.FIELD_TYPE='#{session[:sport]}' AND t.FROM_TIME>='#{@next_hour}' AND t.FROM_TIME<'#{@next_two_hour}'")
      if @fields_2.size > 0
        
        @index = 0
        @fields_2.each do |g|
          if g.ACTIVITY == "未预定"
            @venue_state_2 = "未预定"
          end
          if(@index == 0)
            @min_price_2 = g.PRICE
            @max_price_2 = g.PRICE
          else
            if g.PRICE > @max_price_2
              @max_price_2 = g.PRICE
            end
            if g.PRICE < @min_price_2
              @min_price_2 = g.PRICE
            end
          end
          @index = @index+1
        end
      end
      
      @fields_3 = TFieldBadmintoonActivity.find_by_sql("SELECT t.ID,t.PRICE,t.ACTIVITY FROM `exercise-test`.t_field_badmintoon_activity t WHERE t.VENUE_ID='#{f[:ID]}' AND t.FIELD_TYPE='#{session[:sport]}' AND t.FROM_TIME>='#{@next_two_hour}' AND t.FROM_TIME<'#{@next_three_hour}'")
      if @fields_3.size > 0
        
        @index = 0
        @fields_3.each do |g|
          if g.ACTIVITY == "未预定"
            @venue_state_3 = "未预定"
          end
          if(@index == 0)
            @min_price_3 = g.PRICE
            @max_price_3 = g.PRICE
          else
            if g.PRICE > @max_price_3
              @max_price_3 = g.PRICE
            end
            if g.PRICE < @min_price_3
              @min_price_3 = g.PRICE
            end
          end
          @index = @index+1
        end
      end 

        @min_price = min(@min_price_1,@min_price_2,@min_price_3)
        @max_price = max(@max_price_1,@max_price_2,@max_price_3)
        if @min_price < @max_price
          @price = "#{@min_price}-#{@max_price}"
        else
          @price = "#{@min_price}"
        end

      @show_records.push([session[:search_date],@price,[@venue_state_1,@venue_state_2,@venue_state_3]])
    end
    
#    @users_cards2 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"
#    @users_cards3 = UsersCard.paginate :page => params[:page]||1, :per_page => 7,:conditions=>"user_id=#{session[:user]}"
    @other_venues = TFieldOrder.paginate_by_sql([%!SELECT DISTINCT t_venue_info.ID, t_venue_info.VENUE_NAME FROM t_field_badmintoon_activity, t_venue_info WHERE t_field_badmintoon_activity.FIELD_TYPE="#{session[:sport]}" AND t_field_badmintoon_activity.FROM_TIME>='#{@next_three_hour}' AND t_field_badmintoon_activity.VENUE_ID=t_venue_info.ID AND t_field_badmintoon_activity.USABLE_DATE='#{session[:search_date]}' AND t_venue_info.CITY="#{session[:city]}" AND t_venue_info.DISTRICT='#{session[:region]}' AND t_field_badmintoon_activity.ACTIVITY='未预定'!, true], :page => params[:page]||1, :per_page => 7)
    
    @show_other_records = []
    @other_venues.each do |f|
      @other_min_price
      @other_max_price
      @other_price
      @other_venue_state = "已预定"
      @current_hour_time = @next_three_hour_time
      @next_hour_time = @current_hour_time+3600
      @current_hour = @current_hour_time.strftime("%H:%M").to_s
      @next_hour = @next_hour_time.strftime("%H:%M").to_s
      @final_hour = Time.parse('23:00') 
      @time_for_unbooking_array = []
      @index = 0
      while @current_hour_time.hour < @final_hour.hour     #不确定可否比较
         @other_fields = TFieldBadmintoonActivity.find_by_sql("SELECT t.ID,t.PRICE,t.ACTIVITY FROM `exercise-test`.t_field_badmintoon_activity t WHERE t.VENUE_ID='#{f[:ID]}' AND t.FIELD_TYPE='#{session[:sport]}' AND t.FROM_TIME>='#{@current_hour}' AND t.FROM_TIME<'#{@next_hour}' AND t.ACTIVITY='未预定'")
        if @other_fields.size > 0
        
          @other_fields.each do |g|
            if g.ACTIVITY = "未预定"
              @other_venue_state = "未预定"
            end
            if(@index == 0)
              @other_min_price = g.PRICE
              @other_max_price = g.PRICE
              @index = @index+1
            else
              if g.PRICE > @other_max_price
                @other_max_price = g.PRICE
              end
              if g.PRICE < @other_min_price
                @other_min_price = g.PRICE
              end
            end
    
          end
        @time_for_unbooking_array.push(@current_hour)
        
        end
        @current_hour_time = @next_hour_time
        @next_hour_time = @current_hour_time+3600
        @current_hour = @current_hour_time.strftime("%H:%M").to_s
        @next_hour = @next_hour_time.strftime("%H:%M").to_s
      end

      if @other_min_price < @other_max_price
        @price = "#{@other_min_price}-#{@other_max_price}"
      else
        @price = "#{@other_min_price}"
      end
      @show_other_records.push([session[:search_date],@price,@time_for_unbooking_array])
    end
    
    #第三部分
    @unnegotiated_venues = TVenueMemberInfo.paginate_by_sql([%!SELECT DISTINCT t.VENUE_NAME FROM `exercise-test`.t_venue_member_info t!, true], :page => params[:page]||1, :per_page => 7)

    
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
  
  def min(*elements)
    
    @index =0
    while elements[@index] == nil
      @index = @index + 1
    end
    puts "sdfadfsadfasfasf"
    @min_element = elements[@index]
    elements.each do |f|
      unless f == nil
        if f<@min_element
          @min_element = f
        end
      end
    end
    return @min_element
    en
  end
  
  def max(*elements)
    @index =0
    while elements[@index] == nil
      @index = @index + 1
    end
    @max_element = elements[@index]
    elements.each do |f|
      unless f == nil
        if f>@max_element
          @max_element = f
        end
      end
    end
    return @max_element
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

