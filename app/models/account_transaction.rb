class AccountTransaction < ApplicationRecord
  validates :account_id, :processed_on, :uid, presence: true
  validates :deposit, :credit, numericality: true

  validates :account_id, uniqueness: { scope: :uid }

  belongs_to :account

  def human_amount
    Money.new((deposit.positive? ? deposit : - credit) * 100, iso_currency_code).format
  end
end
