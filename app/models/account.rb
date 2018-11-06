class Account < ApplicationRecord
  # INFO: Plaid account types RFC: https://plaid.com/docs/#accounts
  ACCOUNT_TYPES = %w[brokerage credit depository loan mortgage other].freeze

  # TODO: Customer
  # Unverified - for every new signup
  # Transitions to [pending]
  # Pending - verification in process
  # Transitions to [document, retry, verified, suspended]
  # Document - ID document scan required for verification
  # Transitions to [pending (-> [retry, verified])]
  # Retry - Full SSN required for verification.
  # Transitions to [pending (-> [suspended, verified])]
  # Suspended - Customer can be also suspended manually but you'll need to contact Dwolla to unsuspend the Customer
  # Verified - customer passed all verifications
  # Transitions to [deactivated]
  # Deactivated - can be deactivated by Dwolla if certain ACH return codes are triggered on bank transfer failures
  # Transitions to previous state

  enum account_type: ACCOUNT_TYPES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :user_id, :plaid_token, presence: true
  validates :balance, numericality: true

  belongs_to :user

  serialize :plaid_identity, PlaidIdentity

  after_commit :dwolla_fetch_token, :assign_to_invest_set, :plaid_fetch_identity, on: :create

  def ready?
    plaid_token.present? && dwolla_token.present? && !new_record?
  end

  def currency
    Currency.by_iso(iso_currency_code)
  end

  private

  def assign_to_invest_set
    raise NoMethodError, 'assign_to_invest_set doesn\'t exist'
  end

  def current_invest_set
    @current_invest_set ||= user&.current_invest_set
  end

  def dwolla_fetch_token
    DwollaFetchTokensJob.perform_later(id: id)
  end

  def plaid_fetch_identity
    PlaidFetchIdentityJob.perform_later(id: id)
  end
end
