class Payover < ActionMailer::Base
  
  #recipients代表接收者，body代表内容，subje代表主题，from代表发送者
  def notifyUser(recipients,body,subject,from)
    @subject = subject
    @body = body
    @recipients = recipients
    @from = from
    @sent_on = Time.now
    @content_type= "text/html"
  end

end
