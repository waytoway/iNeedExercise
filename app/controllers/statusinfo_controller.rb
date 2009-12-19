class StatusinfoController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  
  def index
    if params[:venue_id]!=nil && params[:from_time]!=nil && params[:field_type]
    @venue = TVenueInfo.find(:all, :condition=>"VENUE_ID=#{params[:venue_id]} and ")
     @fields = TFieldBadmintoonActivity.find(:all, :conditions => {:VENUE_ID => f[:ID], :FIELD_TYPE => "羽毛球", :FROM_TIME => "07:00"})
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
