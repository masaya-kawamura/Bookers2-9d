class EventMailer < ApplicationMailer
  def send_mail(group_users, title, content)
    @title = title
    @content = content
    mail bcc: group_users.pluck(:email), subject: title
  end
end
