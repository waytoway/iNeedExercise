class Payover < ActionMailer::Base
  
  def notifyUser(recipients,body,subject,from)
    @subject = subject
    @body = body
    @recipients = recipients
    @from = from
    @sent_on = Time.now
    @content_type= "text/html"
  end

end
