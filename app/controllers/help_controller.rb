class HelpController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_page_title
  
  def index
    
  end
  
  def helper_page
    if params[:title] != nil
      @page = Page.find(:first, :conditions => {:title => params[:title]})
    elsif params[:id] != nil
      @cur_page = Page.find(:first, :conditions => {:id => params[:id]})
      @page = Page.find(:first, :conditions => {:id => @cur_page[:parent_id]})
    end
    render :partial => "helper_page"
  end
  
  def modify_page
    if request.post?
      puts "aaaaaaaaaaaaaaaaaaaaa"
      puts "jinrupost"
    end
  end
  
  def modifiabe_helper_page
    unless request.post?
      puts "ddddddddddddddddddd"
      puts "jinrupost"
    else
      puts "ttttttttttttttttttttt"
      puts "jinrupost"
      if params[:title] != nil
        @page = Page.find(:first, :conditions => {:title => params[:title]})
      elsif params[:id] != nil
        @cur_page = Page.find(:first, :conditions => {:id => params[:id]})
        @page = Page.find(:first, :conditions => {:id => @cur_page[:parent_id]})
      end
      render :partial => "modifiabe_helper_page"
    end

  end
  
  protected
  def get_page_title
    @pages = Page.find(:all)
  end
  
end
