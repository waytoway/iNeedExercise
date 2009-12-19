class OrderController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  
  def index
    puts session[:user]
  end
  
  def create
    
  end
  
  def payThisOrder
    
  end
  
  
end
