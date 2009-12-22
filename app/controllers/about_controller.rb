class AboutController < ApplicationController
  include AuthenticatedSystem
  uses_tiny_mce( :options => {   
    :theme => 'advanced',  # 皮肤   
    :language => 'zh',  # 中文界面   
    :convert_urls => false, # 不转换路径，否则在插入图片或头像时，会转成相对路径，容易导致路径错乱。   
    :theme_advanced_toolbar_location => "top",  # 工具条在上面   
    :theme_advanced_toolbar_align => "left",   
    :theme_advanced_resizing => true,  # 似乎不好使   
    :theme_advanced_resize_horizontal => false,   
    # 工具条上的按钮布局   
    :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect forecolor backcolor bold italic underline strikethrough sub sup removeformat},   
    :theme_advanced_buttons2 => %w{undo redo cut copy paste separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator link unlink image media emotions separator table separator fullscreen},   
    :theme_advanced_buttons3 => []})   
  # 字体列表中显示的字体   
  before_filter :login_from_cookie
  before_filter :get_page_title
  
  def index
    @user_id = session[:user]
    @is_admin = User.isAdmin?(@user_id)
    
  end
  
  def save_commit_modify
    if request.post?
      @content = params[:body]
      @page = Page.find(:first, :conditions => {:title => "关于我们"})
      @page.update_attributes(:content => @content)
      render :text=>"修改成功"
    end
  end
  
  protected
  def get_page_title
    @page = Page.find(:first, :conditions => {:title => "关于我们"})
  end
end
