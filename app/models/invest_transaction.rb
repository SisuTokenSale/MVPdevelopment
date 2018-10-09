class InvestTransaction < ApplicationRecord
  validates :invest_set_id,
            :source_account_id,
            :invest_account_id, presence: true

  belongs_to :invest_set
  belongs_to :source_account
  belongs_to :invest_account
end
