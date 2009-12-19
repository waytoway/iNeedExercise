class StatusinfoController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  
  def index
    #测试数据====
    params[:venue_id]=2
    params[:from_time]="07:00"
    params[:field_type]="羽毛球"
    params[:usable_time]="2009-12-20"
    #测试数据====
    
    #查询所有该场馆的项目
    @all_type =TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FIELD_TYPE='#{params[:field_type]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")

    
    if params[:venue_id]!=nil && params[:from_time]!=nil && params[:field_type]
      @span_time=Time.parse params[:from_time] 
      #时间跨度为1小时，查询1个小时内的所有可预定记录
      @span_time=@span_time+3600
      #查询所有的符合日期，时间，场馆，项目的记录
      @query_records =TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FIELD_TYPE='#{params[:field_type]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")
    end
  end
  
  def show_map
    redirect_to params[:url]
  end
  
  def get_field
    render :update do |page|
      page.replace_html 'content' , :partial => 'status'
    end
  end
end
