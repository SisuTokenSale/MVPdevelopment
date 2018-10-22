class UserMailer < ApplicationMailer
  default from: 'processors@sisu-staging.herokuapp.com'
  def transaction_mail
    @subject = params[:subject]
    @email = params[:email] || 'support@sisu-staging.herokuapp.com'
    @message = params[:message]
    mail(to: 'support@sisu-staging.herokuapp.com', subject: @subject)
  end
end
