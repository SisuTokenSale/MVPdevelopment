class InvestSetService
  attr_reader :user, :invest_set, :invest_transaction, :valid

  def initialize(opts = {})
    raise(ArgumentError, 'opts[:user] required!') unless opts[:user]

    @user = opts[:user]
  end

  def create(opts = {})
    raise(ArgumentError, 'opts[:invest_set] required!') unless opts[:invest_set]

    @invest_set = user.invest_sets.new(opts[:invest_set])
    @invest_transaction = InvestTransaction.new(opts[:invest_transaction]) if opts[:invest_transaction]&.delete(:required)

    assign_accounts
    InvestSet.transaction do
      invest_set.save!
      if invest_transaction
        invest_transaction.invest_set = invest_set
        invest_transaction.save!
      end
    end
    valid!
    Mailer.recurring_payment_initiated(invest_set).deliver_later
    self
  rescue StandardError => _e
    self
  end

  def valid!
    @valid = true
  end

  def valid?
    valid == true
  end

  private

  def assign_accounts
    invest_set.source_account = user.current_invest_set&.source_account || user.last_source_account
    invest_set.invest_account = user.current_invest_set&.invest_account || user.last_invest_account
  end
end
