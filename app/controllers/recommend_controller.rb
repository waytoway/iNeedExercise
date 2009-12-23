class HelpController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required  
  before_filter :login_from_cookie

  def index
    
  end
end
