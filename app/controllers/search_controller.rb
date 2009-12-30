class SearchController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_user_cards

  
  def index
    @city_name = params[:city_name]
    if @city_name == nil
      @region_name = '选择区域'
      @sport_name = '运动项目'
      @search_date = ''
      @search_time = '12:00'
      @check_on_map = false
    else
      @region_name = params[:region_name]
      @sport_name = params[:sport_type_name]
      @search_date = params[:search_date]
      @search_time = params[:search_time]
      @check_on_map = params[:check_on_map]
    end
    if request.post?
      @city_name = params[:city][:name]
      @region_name = params[:region][:name]
      @sport_name = params[:sport][:name]
      @search_date = params[:search_date]
      @search_time = params[:time]
    end 
    
    @cur_time=Time.parse @search_time
    @next_three_hour_time = @cur_time+10800
    @next_three_hour = @next_three_hour_time.strftime("%H:%M").to_s
    
    @venues = TFieldBadmintoonActivity.paginate_by_sql([%!SELECT DISTINCT t_venue_info.ID, t_venue_info.VENUE_NAME FROM t_field_badmintoon_activity, t_venue_info WHERE t_field_badmintoon_activity.FIELD_TYPE="#{@sport_name}" AND t_field_badmintoon_activity.FROM_TIME>='#{@search_time}' AND t_field_badmintoon_activity.FROM_TIME<'#{@next_three_hour}' AND t_field_badmintoon_activity.VENUE_ID=t_venue_info.ID AND t_field_badmintoon_activity.USABLE_DATE='#{@search_date}' AND t_venue_info.CITY="#{@city_name}" AND t_venue_info.DISTRICT='#{@region_name}' AND t_field_badmintoon_activity.ACTIVITY='未预订'!, true], :page => params[:page]||1, :per_page => 7)
    @show_records = get_assign_time_record(@sport_name,@search_date,@search_time,@venues)
    
    @other_venues = TFieldBadmintoonActivity.paginate_by_sql([%!SELECT DISTINCT t_venue_info.ID, t_venue_info.VENUE_NAME FROM t_field_badmintoon_activity, t_venue_info WHERE t_field_badmintoon_activity.FIELD_TYPE="#{@sport_name}" AND t_field_badmintoon_activity.FROM_TIME>='#{@next_three_hour}' AND t_field_badmintoon_activity.VENUE_ID=t_venue_info.ID AND t_field_badmintoon_activity.USABLE_DATE='#{@search_date}' AND t_venue_info.CITY="#{@city_name}" AND t_venue_info.DISTRICT='#{@region_name}' AND t_field_badmintoon_activity.ACTIVITY='未预订'!, true], :page => params[:page]||1, :per_page => 7)
    @show_other_records = get_other_time_record(@sport_name,@search_date,@next_three_hour_time,@other_venues)
    
    #第三部分
    @unnegotiated_venues = TVenueMemberInfo.paginate_by_sql([%!SELECT DISTINCT t.VENUE_NAME FROM t_venue_member_info t!, true], :page => params[:page]||1, :per_page => 7)
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
  
  def fields_activity_and_price(fields)
    activity_and_price = []
    @venue_state = "已预订"
    if fields.size != 0       
      @index = 0       
      fields.each do |g|
        if g.ACTIVITY == "未预订"
          @venue_state = "未预订"
        end
        if(@index == 0)
          @min_price = g.PRICE
          @max_price = g.PRICE
        else
          if g.PRICE > @max_price
            @max_price = g.PRICE
          end
          if g.PRICE < @min_price
            @min_price = g.PRICE
          end
        end
        @index = @index+1
      end
      activity_and_price.push([@venue_state,@min_price,@max_price])
      return activity_and_price
    else
      activity_and_price.push([@venue_state,nil,nil])
      return activity_and_price
    end
  end
  
  def get_assign_time_record(sport,date,time,venues)
    @cur_time=Time.parse time
    @next_hour_time = @cur_time+3600
    @next_two_hour_time = @cur_time+7200
    @next_three_hour_time = @cur_time+10800
    @next_hour = @next_hour_time.strftime("%H:%M").to_s
    @next_two_hour = @next_two_hour_time.strftime("%H:%M").to_s
    @next_three_hour = @next_three_hour_time.strftime("%H:%M").to_s
    @show_records = []
 
    venues.each do |f|
      @min_price
      @max_price
      @price
      
      @fields_1 = TFieldBadmintoonActivity.one_hour_fields f[:ID],sport,date,time,@next_hour
      part1_record = fields_activity_and_price(@fields_1)
      @venue_state_1 = part1_record[0][0]
      @min_price_1 = part1_record[0][1]
      @max_price_1 = part1_record[0][2]
      
      @fields_2 = TFieldBadmintoonActivity.one_hour_fields f[:ID],sport,date,@next_hour,@next_two_hour
      part2_record = fields_activity_and_price(@fields_2)
      @venue_state_2 = part2_record[0][0]
      @min_price_2 = part2_record[0][1]
      @max_price_2 = part2_record[0][2]
      
      @fields_3 = TFieldBadmintoonActivity.one_hour_fields f[:ID],sport,date,@next_two_hour,@next_three_hour
      part3_record = fields_activity_and_price(@fields_3)
      @venue_state_3 = part3_record[0][0]
      @min_price_3 = part3_record[0][1]
      @max_price_3 = part3_record[0][2]

      @min_price = min(@min_price_1,@min_price_2,@min_price_3)
      @max_price = max(@max_price_1,@max_price_2,@max_price_3)
      @price = joint_price(@min_price,@max_price)


      @show_records.push([date,@price,[@venue_state_1,@venue_state_2,@venue_state_3]])
    end
    return @show_records
  end
  
  def get_other_time_record(sport,date,time,venues)
    @show_other_records = []
    venues.each do |f|
      @min_price_array = []
      @max_price_array = []
      @other_price
      @current_hour_time = time
      @next_hour_time = @current_hour_time+3600
      @current_hour = @current_hour_time.strftime("%H:%M").to_s
      @next_hour = @next_hour_time.strftime("%H:%M").to_s
      @final_hour = Time.parse('23:00') 
      @time_for_unbooking_array = []
      @index = 0
      while @current_hour_time.hour < @final_hour.hour     #不确定可否比较
        @other_fields = TFieldBadmintoonActivity.all_inactivicy_fields f[:ID],sport,date,@current_hour,@next_hour
        part_record = fields_activity_and_price(@other_fields)
        if part_record[0][0] == '未预订'
          @time_for_unbooking_array.push(@current_hour)
          @min_price_array.push(part_record[0][1])
          @max_price_array.push(part_record[0][2])
        end
        @current_hour_time = @next_hour_time
        @next_hour_time = @current_hour_time+3600
        @current_hour = @current_hour_time.strftime("%H:%M").to_s
        @next_hour = @next_hour_time.strftime("%H:%M").to_s
      end

      @min_price = min(@min_price_array)
      @max_price = max(@max_price_array)
      if @min_price < @max_price
        @price = "#{@min_price}-#{@max_price}"
      else
        @price = "#{@min_price}"
      end
      @show_other_records.push([@search_date,@price,@time_for_unbooking_array])
    end
    return @show_other_records
  end
  
  def joint_price(low,high)
      if low < high
        @price = "#{low}-#{high}"
      else
        @price = "#{low}"
      end
  end
  
  protected
  def get_user_cards
  end
end  

