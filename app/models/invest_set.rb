class InvestSet < ApplicationRecord
  validates :user_id,
            :source_account_id,
            :invest_account_id, presence: true

  belongs_to :user
  belongs_to :source_account
  belongs_to :invest_account

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
