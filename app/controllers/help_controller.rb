class HelpController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_page_title
  
  def index
    @user_id = session[:user]
    @is_admin = User.isAdmin?(@user_id)
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
    
  end
  
  def modifiabe_helper_page
    if request.post?
      if params[:title] != nil
        @page = Page.find(:first, :conditions => {:title => params[:title]})
      elsif params[:id] != nil
        @cur_page = Page.find(:first, :conditions => {:id => params[:id]})
        @page = Page.find(:first, :conditions => {:id => @cur_page[:parent_id]})
      end
      render :partial => "modifiabe_helper_page"
    end

  end

  def save_modify
   if request.post?
      @title = params[:title]
      @content = params[:content]
      @page = Page.find(:first, :conditions => {:title => @title})
      @page.update_attributes(:title => @title)
      @page.update_attributes(:content => @content)
      
      render :text=>"修改成功"
    end
  end
  
  protected
  def get_page_title
    @pages = Page.find(:all)
  end
  
end
