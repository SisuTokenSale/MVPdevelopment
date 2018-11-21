class UserMailer < ApplicationMailer
  default from: 'processors@sisu-staging.herokuapp.com'
  def transaction_mail
    @subject = params[:subject]
    @email = params[:email] || 'dmitriy.bielorusov@syndicode.com'
    @message = params[:message]
    mail(to: @email, subject: @subject)
  end
end
