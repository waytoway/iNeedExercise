class StatusinfoController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  def index
    #如果传进来的是查询某项目状态，则返回一个tab
    
    if params[:venue_id]!=nil && params[:from_time]!=nil 
      @tabs=[]
      @span_time=Time.parse params[:from_time] 
      @span_time=@span_time+3600
      if params[:field_type]!=nil
        #查询所有的符合日期，时间，场馆，项目的记录
        @query_records =TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FIELD_TYPE='#{params[:field_type]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")
        @tabs.push(params[:field_type])  
      else
      #如果传进来的是查询场馆状态
        @records=TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")
        if @records!=nil
          #查询所有设施种类
          @records.each do |record|
            if @tabs.include?(record[:FIELD_TYPE])==false
               @tabs.push(record[:FIELD_TYPE])
            end
          end
          #查询第一个项目记录
          @query_records= TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FIELD_TYPE='#{@tabs[0]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")
        end
      end
  else
  redirect_to "http://bbs.nju.edu.cn"
end
end

def show_map
redirect_to params[:url]
end

def get_field
      @span_time=Time.parse params[:from_time] 
      @span_time=@span_time+3600
      @query_records =TFieldBadmintoonActivity.find_by_sql("select * from t_field_badmintoon_activity where VENUE_ID='#{params[:venue_id]}' and FIELD_TYPE='#{params[:field_type]}' and FROM_TIME>='#{params[:from_time]}' and FROM_TIME<'#{@span_time.strftime("%H:%M").to_s}' and USABLE_DATE='#{params[:usable_time]}'")
      render :update do |page|
page.replace_html 'content' , :partial => 'status'
end
end
end