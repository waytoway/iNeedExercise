class UserController < ApplicationController
  before_filter :login_required
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :find_user
  def index
    #redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    
  end
  
  def login_infor
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
  
  protected
  def find_user
    @user = User.find(session[:user_id])
  end
end
