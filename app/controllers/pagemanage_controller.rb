class PagemanageController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :get_page_title
    uses_tiny_mce( 
    :options => {   
    :theme => 'advanced',  # 皮肤   
    :convert_urls => false, # 不转换路径，否则在插入图片或头像时，会转成相对路径，容易导致路径错乱。   
    :theme_advanced_toolbar_location => "top",  # 工具条在上面   
    :theme_advanced_toolbar_align => "left",   
    :theme_advanced_resizing => true,  
    :theme_advanced_resize_horizontal => false,   
    # 工具条上的按钮布局   
    :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect forecolor backcolor bold italic underline strikethrough sub sup removeformat},   
    :theme_advanced_buttons2 => %w{undo redo cut copy paste separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator link unlink image media emotions separator table separator fullscreen},   
    :theme_advanced_buttons3 => [],
    :theme_advanced_blockformats => %w{p,div,h1,h2,h3,h4,h5,h6,blockquote,dt,dd,code,samp},
    :theme_advanced_fonts => %w{宋体=宋体;黑体=黑体;仿宋=仿宋;楷体=楷体;隶书=隶书;幼圆=幼圆;Andale Mono=andale mono,times;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;Comic Sans MS=comic sans ms,sans-serif;Courier New=courier new,courier;Georgia=georgia,palatino;Helvetica=helvetica;Impact=impact,chicago;Symbol=symbol;Tahoma=tahoma,arial,helvetica,sans-serif;Terminal=terminal,monaco;Times New Roman=times new roman,times;Trebuchet MS=trebuchet ms,geneva;Verdana=verdana,geneva;Webdings=webdings;Wingdings=wingdings,zapf dingbats},  
    :plugins => %w{contextmenu paste media emotions table fullscreen inlinepopups }})   
  # 字体列表中显示的字体   
  def index
  end

  def about
    @pages = Page.find(:all, :conditions => {:parent_id => 3})
    @parent_id = 3
  end
  
  def contact
    @pages = Page.find(:all, :conditions => {:parent_id => 2})
    @parent_id = 2
  end
  
  def help
    @pages = Page.find(:all, :conditions => {:parent_id => 1})
    @parent_id = 1
  end
  
  def modify_help
    @parent_id = params[:parent_id]
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})
    @id = params[:id]
    session[:help_id] = @id
    @page = Page.find(:first, :conditions => {:id => @id})
  end
  
  def modify_about
    @parent_id = params[:parent_id]
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})
    @id = params[:id]
    session[:about_id] = @id
    @page = Page.find(:first, :conditions => {:id => @id})
  end
  
  def modify_contact
    @parent_id = params[:parent_id]
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})
    @id = params[:id]
    session[:contact_id] = @id
    @page = Page.find(:first, :conditions => {:id => @id})
  end
  
  def new_help_page
    @parent_id = params[:parent_id]
    @page = Page.new
    @lastPage = Page.find(:last)
    @page.id = @lastPage.id+1
    @page.title = "新帮助页面" +(@page.id).to_s
    @page.parent_id = 1
    @page.save!
    session[:help_id] = @page.id
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})
  end
  
  def new_contact_page
    @parent_id = params[:parent_id]
    @page = Page.new
    @lastPage = Page.find(:last)
    @page.id = @lastPage.id+1
    @page.title = "新帮助页面" +(@page.id).to_s
    @page.parent_id = 2
    @page.save!
    session[:contact_id] = @page.id
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})

  end
  
  def new_about_page
    @parent_id = params[:parent_id]
    @page = Page.new
    @lastPage = Page.find(:last)
    @page.id = @lastPage.id+1
    @page.title = "新帮助页面" +(@page.id).to_s
    @page.parent_id = 3
    @page.save!
    session[:about_id] = @page.id
    @pages = Page.find(:all, :conditions => {:parent_id => @parent_id})
  end
  
  def save_help_modify
    if request.post?
      if session[:help_id]!= nil
        @content = params[:body]
        @title = params[:title]
        @page = Page.find(:first, :conditions => {:id => session[:help_id]})
        @page.update_attributes(:title => @title,:content => @content)
        render :text=>"修改成功"
      else
        render :text=>"修改失败"
      end
    end
  end
  
  def save_contact_modify
    if request.post?
      if session[:contact_id]!= nil
        @content = params[:body]
        @title = params[:title]
        @page = Page.find(:first, :conditions => {:id => session[:contact_id]})
        @page.update_attributes(:title => @title,:content => @content)
        render :text=>"修改成功"
      else
        render :text=>"修改失败"
      end
    end
  end
  
  def save_about_modify
    if request.post?
      if session[:about_id]!= nil
        @content = params[:body]
        @title = params[:title]
        @page = Page.find(:first, :conditions => {:id => session[:about_id]})
        @page.update_attributes(:title => @title,:content => @content)
      render :text=>"修改成功"
      else
        render :text=>"修改失败"
      end
      
    end
  end
  
  protected
  def get_page_title
    @page = Page.find(:first, :conditions => {:title => "帮助中心"})
  end
  
end
