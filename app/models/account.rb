class Account < ApplicationRecord
  # INFO: Plaid account types RFC: https://plaid.com/docs/#accounts
  ACCOUNT_TYPES = %w[brokerage credit depository loan mortgage other].freeze

  enum account_type: ACCOUNT_TYPES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :user_id, :plaid_token, presence: true
  validates :balance, numericality: true

  belongs_to :user

  after_create :dwolla_fetch_token, :assign_to_invest_set

  def ready?
    plaid_token.present? && dwolla_token.present?
  end

  private

  def assign_to_invest_set
    raise NoMethodError, 'assign_to_invest_set doesn\'t exist'
  end

  def current_invest_set
    @current_invest_set ||= user&.current_invest_set
  end

  def dwolla_fetch_token
    DwollaFetchTokensJob.perform_now(id: id)
  end
end
