class InvestSet < ApplicationRecord
  FREQUENCIES = %w[once daily weekly monthly lowest algo].freeze
  MIN_AMOUNT = 5.0
  MAX_AMOUNT = 5000.0

  attribute :frequency, :string, default: FREQUENCIES[1]
  attribute :amount, :decimal, default: MIN_AMOUNT
  attribute :rel_min_balance, :decimal, default: 5.0

  enum frequency: FREQUENCIES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

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

  delegate :currency, to: :source_account, allow_nil: true

  def human_amount
    Money.new(amount * 100, currency.iso_code).format
  end

  def ready?
    source_account&.ready? && invest_account&.ready? && !new_record?
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
