class UserController < ApplicationController
  before_filter :login_required
  include AuthenticatedSystem
  before_filter :login_from_cookie
  def index
    #redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    
  end
end
