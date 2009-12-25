class Payover < ActionMailer::Base
  
  def notifyUser(name,email)
    @subject = "test"
    @body = "a lot of tests"
    @recipients = "caijiaddk@sina.com"
    @from = "abaofmin@gmail.com"
    @sent_on = Time.now
    @content_type= "text/html"
  end

end
