class User < ApplicationRecord
  INVEST_STRATEGIES = {
    daily: 1.day,
    weekly: 7.days,
    montly: 1.month
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :source_account, dependent: :destroy
  has_one :invest_account, dependent: :destroy

  validates :strategy, inclusion: { in: INVEST_STRATEGIES.keys.map(&:to_s) }, allow_nil: true
end
