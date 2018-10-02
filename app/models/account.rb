class Account < ApplicationRecord
  validates :user_id, :type, :account_id, presence: true
  validates :balance, numericality: true, presence: true

  belongs_to :user
end
