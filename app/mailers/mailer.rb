class Mailer < ApplicationMailer
  def account_created(user)
    @user = user
    mail to: @user.email, subject: 'NEW ACCOUNT CREATED'
  end

  def customer_verified(customer)
    @user = customer.user
    mail to: @user.email, subject: 'YOUR ACCOUNT AT SISU HAS BEEN VERIFIED'
  end

  def customer_suspended(customer)
    @user = customer.user
    mail to: @user.email, subject: 'YOUR ACCOUNT AT SISU HAS BEEN SUSPENDED'
  end

  def customer_verify_needed(customer)
    @user = customer.user
    mail to: @user.email, subject: 'VERIFICATION DOCUMENTATION IS REQUIRED TO APPROVE YOUR ACCOUNT AT SISU'
  end

  def customer_verify_uploaded(customer)
    @user = customer.user
    mail to: @user.email, subject: 'A VERIFICATION DOCUMENTATION HAS BEEN UPLOADED AT SISU'
  end

  def customer_verify_approved(customer)
    @user = customer.user
    mail to: @user.email, subject: 'A VERIFICATION DOCUMENTATION HAS BEEN APPROVED AT SISU'
  end

  def customer_verify_failed(customer)
    @user = customer.user
    mail to: @user.email, subject: 'A VERIFICATION DOCUMENTATION HAS BEEN REJECTED AT SISU'
  end

  def funding_source_added(funding_source)
    @funding_source = funding_source
    @account = @funding_source.account
    @user = @funding_source.user
    @date = @funding_source.created_at.to_date
    mail to: @user.email, subject: 'A FUNDING SOURCE WAS ADDED TO YOUR ACCOUNT AT SISU'
  end

  def funding_source_updated(funding_source)
    @funding_source = funding_source
    @account = @funding_source.account
    @user = @funding_source.user
    @date = @funding_source.created_at.to_date
    mail to: @user.email, subject: 'A FUNDING SOURCE WAS UPDATED IN YOUR ACCOUNT AT SISU'
  end

  def funding_source_verified(funding_source)
    @funding_source = funding_source
    @account = @funding_source.account
    @user = @funding_source.user
    @date = @funding_source.created_at.to_date
    mail to: @user.email, subject: 'A FUNDING SOURCE WAS SUCCESSFULLY VERIFIED FOR YOUR ACCOUNT AT SISU'
  end

  def transfer_initiated(trx)
    @trx = trx
    @date = @trx.created_at.to_date
    @source_account = @trx.source_account
    @invest_account = @trx.invest_account
    @user = @source_account.user
    mail to: @user.email, subject: 'A TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS BEEN INITIATED'
  end

  def transfer_processed(trx)
    @trx = trx
    @date = @trx.processed_at.to_date
    @source_account = @trx.source_account
    @invest_account = @trx.invest_account
    @user = @source_account.user
    mail to: @user.email, subject: ' A TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS BEEN COMPLETED SUCCESSFULLY'
  end

  def transfer_cancelled(trx)
    @trx = trx
    @date = @trx.cancelled_at.to_date
    @source_account = @trx.source_account
    @invest_account = @trx.invest_account
    @user = @source_account.user
    mail to: @user.email, subject: 'A PENDING TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS BEEN CANCELLED'
  end

  def transfer_failed(trx)
    @trx = trx
    @date = @trx.updated_at.to_date
    @source_account = @trx.source_account
    @invest_account = @trx.invest_account
    @user = @source_account.user
    mail to: @user.email, subject: 'A TRANSFER FROM YOUR FUNDING ACCOUNT TO YOUR INVESTMENT ACCOUNT HAS FAILED'
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
