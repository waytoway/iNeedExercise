class MainController < ApplicationController
  session :session_key => '_iNeedExercise_session_id'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  

  def index
    @item = TCardType.find(:first)
    puts @item
  end
  
  def login
    puts 'hello'
  end
  
end
