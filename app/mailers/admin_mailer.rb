class AdminMailer < ActionMailer::Base
  default :to => Proc.new { User.with_role(:admin).pluck(:email) },
          :from => "Southern HopHeads <noreply@southernhopheads.com>"

  def contact_us(message)
    @message = message
    mail(:from => "#{@message.name} <#{@message.email}>", :subject => "Message from a Southern HopHeads visitor")
  end
end
