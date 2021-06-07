class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    WelcomeMailer.send_when_signup(params[:user][:email], params[:user][:name]).deliver
  end

end
