class HelpController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  
  def index
    @venue = TFieldBadmintoonActivity.find(:all, :condition=>"VENUE_ID='2' and FIELD_TYPE='羽毛球' and FROM_TIME='07:00:00'")
    @venue.each do |a|
      puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      puts a[:ACTIVITY]
    end
  end
end
