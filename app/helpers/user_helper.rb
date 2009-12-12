module UserHelper
  def modify_login_infor
    puts "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    redirect_to :controller=>:user ,:action => "index"
    return unless request.post?
    puts params[:user][:email]
    unless @user.update_attributes!(:email => params[:user][:email])
      flash[:notice] = "Email can't be blank or is too short!"
    end
    unless @user.update_attributes!(:cell => params[:user][:cell])
      flash[:notice] = "Cell can't be blank or is too short!"
    end
    redirect_to :action => "index" 
  end
end
