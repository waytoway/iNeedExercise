class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :navigator 
  
  def index
  end
  def navigator
    @navigators = Page.navigator(session[:user])
  end
end
