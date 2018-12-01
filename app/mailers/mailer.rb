class Mailer < ApplicationMailer
  def new_account_created(user)
    @user = user
    mail to: @user.email, subject: 'NEW ACCOUNT CREATED'
  end

  def transfer_was_initiated(trx)
    @trx = trx
    @source_account = @trx.source_account
    @invest_account = @trx.invest_account
    @user = @source_account.user
    mail to: @user.email, subject: 'A TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS BEEN INITIATED'
  end

  def recurring_payment_initiated(invest_set)
    @invest_set = invest_set
    @source_account = @invest_set.source_account
    @invest_account = @invest_set.invest_account
    @user = @invest_set.user
    mail to: @user.email,
         subject: 'A RECURRING TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS BEEN INITIATED'
  end
end
