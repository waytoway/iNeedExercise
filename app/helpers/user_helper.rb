module UserHelper
  
  def pass_too_short?(password,password_confirmation)
    password.size<6 || password_confirmation.size<6
  end
  
  def pass_not_equal?(password,password_confirmation)
    params[:password] != params[:password_confirmation]
  end
end
