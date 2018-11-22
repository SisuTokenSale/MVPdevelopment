class InvestSet < ApplicationRecord
  STATUSES = %w[active cancelled].freeze
  FREQUENCIES = %w[daily weekly monthly lowest algo].freeze
  MIN_AMOUNT = 5.0
  MAX_AMOUNT = 5000.0

  attribute :amount, :decimal, default: MIN_AMOUNT
  attribute :rel_min_balance, :decimal, default: 5.0

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :frequency, inclusion: { in: FREQUENCIES }

  validates :user_id,
            :source_account_id,
            :invest_account_id, presence: true

  validates :amount,
            numericality: {
              greater_than_or_equal_to: MIN_AMOUNT,
              less_than_or_equal_to: MAX_AMOUNT
            }

  validates :rel_min_balance,
            numericality: {
              greater_than_or_equal_to: 5.0,
              less_than_or_equal_to: 90
            }

  belongs_to :user
  belongs_to :source_account
  belongs_to :invest_account
  has_many :invest_transactions, dependent: :destroy

  scope :for_cancelling, -> { where(status: %w[active]) }
  scope :activated, -> { where(status: 'active') }
  scope :planned_periodical_transactions, -> { invest_transactions.periodical.where('will_processed_at > ?', Time.current) }

  delegate :currency, to: :source_account, allow_nil: true

  after_commit :cancelling_others, on: :create

  def human_amount
    Money.new(amount * 100, currency.iso_code).format
  end

  def ready?
    source_account&.ready? && invest_account&.ready? && !new_record? && active?
  end

  def cascade_cancel!
    # TODO: In BG Job
    # - Cancel all active InvestSets
    # - Cancel all planned & pending transactions for InvestSet User
    # - Set cancelled_at after up operations
    # NOTICE: All should be processed in Transaction block
    transaction do
      cancel_invest_set! && cancel_invest_transactions!
    end
  end

  def cancelled?
    cancelled_at && super
  end

  def cancel_with_options!(opts = {})
    return unless opts[:cancel]

    transaction do
      cancel_invest_set! if 'investments'.in?(opts[:cancel])
      cancel_invest_transactions! if 'transactions'.in?(opts[:cancel])
    end
  end

  def planned_periodical_transactions?
    planned_periodical_transactions.count.positive?
  end

  private

  def cancel_invest_transactions!
    # TODO: Will do that in BG JOB
    invest_transactions.where(status: 'planned').find_each(batch_size: 5).each(&:cancelled!)
  end

  def cancel_invest_set!
    self.cancelled_at = Time.current
    cancelled!
  end

  def cancelling_others
    # TODO: Will do that in BG JOB
    user.invest_sets.for_cancelling.where.not(id: id).find_each(batch_size: 5).each(&:cascade_cancel!)
  end

  # before_validation :assign_latest_accounts
  # INFO: Set Source and Invest accounts from previous active InvestSet
  # def assign_latest_accounts
  #   self.source_account = user.last_source_account || user&.current_invest_set&.source_account
  #   self.invest_account = user.last_invest_account || user&.current_invest_set&.invest_account
  #   # TODO: Need transaction for disable all previous invest_sets & transactions
  #   # Do this only on model layer
  #   # Need discard all Previous InvestSets after create
  # end
end
