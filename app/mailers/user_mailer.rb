class UserMailer < ActionMailer::Base
  include ActionView::Helpers::SanitizeHelper

  default :from => "Southern HopHeads <noreply@southernhopheads.com>"

  def email_article(user, article)
    @user = user
    @article = article
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => @article.title)
  end

  def email_comment(user, comment)
    @user = user
    @comment = comment
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "Another user has commented on \"#{strip_tags(@comment.commentable.title)}\"")
  end
end
