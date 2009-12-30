class PagesController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  uses_tiny_mce  :options => {  
                                :theme => 'advanced',  
                                :theme_advanced_resizing => true,                                 
                                :theme_advanced_resize_horizontal => false,  
                                :plugins => %w{ table fullscreen }  
  } 
  
  def index
    @pages = Page.root
  end
  
  def new
    @page = Page.new
    @page.parent_id = params[:page_id] unless params[:page_id].nil?
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def show
    @page = Page.find(params[:id])
  end
  
  def create
    @page = Page.new(params[:page])
    
    if @page.save
      flash[:notice] = '页面新建成功.'
      redirect_to(@page)
    else
      render :action => "new" 
    end
  end
  
  def update
    @page = Page.find(params[:id]) 
    
    if @page.update_attributes(params[:page])
      flash[:notice] = '页面更新成功.'
      redirect_to(@page)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to(pages_url)
  end
  
  def display
     @page = Page.find(params[:id])
  end
end