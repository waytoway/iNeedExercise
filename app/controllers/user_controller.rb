class UserController < ApplicationController
  before_filter :login_required
  
end
