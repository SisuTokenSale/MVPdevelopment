class NoticeService
  class << self
    def account(user, status)
      # INFO: Available [:created]
      return unless status.in?(%i[created])

      Mailer.send(:"account_#{status}", user).deliver_later
    end

    def customer(customer, status)
      # INFO: Available [verified suspended ...]
      return unless status.in?(%i[verified suspended verify_needed verify_uploaded verify_approved verify_failed])

      Mailer.send(:"customer_#{status}", customer).deliver_later
    end

    def recurring_payment(invest_set, status)
      # INFO: Available [:initiated]
      return unless status.in?(%i[initiated])

      Mailer.send(:"recurring_payment_#{status}", invest_set).deliver_later
    end

    def funding_source(funding_source, status)
      # INFO: Available [:added, :updated, :verified]
      return unless status.in?(%i[added updated verified])

      Mailer.send(:"funding_source_#{status}", funding_source).deliver_later
    end

    def transfer(trx, status)
      # INFO: Available [:initiated, :processed, :cancelled, :failed]
      return unless status.in?(%i[initiated processed cancelled failed])

      Mailer.send(:"transfer_#{status}", trx).deliver_later
    end
  end
end
