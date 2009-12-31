class AboutController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :login_from_cookie
  before_filter :get_page_title
  
  def index
  end
  
  def details
    @parent_id = params[:parent_id]
    @id = params[:id]
    @page = Page.find(:first, :conditions => {:id => @id})
  end
  
  protected
  def get_page_title
    @pages = Page.find(:all, :conditions => {:parent_id => 3})
  end
end
