class AboutController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  
  def index
  end
end
