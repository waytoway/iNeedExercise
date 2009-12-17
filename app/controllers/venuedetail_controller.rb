class VenuedetailController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  def index
    @venue = TVenueInfo.find(1)
    
  end
  def show_map
    redirect_to params[:url]
  end
end
