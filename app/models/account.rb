class Account < ApplicationRecord
  # INFO: Plaid account types RFC: https://plaid.com/docs/#accounts
  ACCOUNT_TYPES = %w[brokerage credit depository loan mortgage other].freeze

  attr_accessor :public_token

  enum account_type: ACCOUNT_TYPES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :user_id, presence: true
  validates :balance, numericality: true

  belongs_to :user
  has_many :account_transactions, dependent: :destroy
  has_one :funding_source, dependent: :destroy

  serialize :plaid_identity, PlaidIdentity

  after_commit :assign_to_invest_set, on: :create

  def ready?
    plaid_token.present? && dwolla_token.present? && !new_record?
  end

  def currency
    return Money.default_currency unless iso_currency_code

    Money::Currency.new(iso_currency_code)
  end

  def human_balance
    Money.new(balance * 100, currency.iso_code).format
  end

  private

  def assign_to_invest_set
    raise NoMethodError, 'assign_to_invest_set doesn\'t exist'
  end

  def current_invest_set
    user&.current_invest_set
  end
end
