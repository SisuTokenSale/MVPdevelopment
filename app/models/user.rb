class User < ApplicationRecord
  enum role: { user: 'user', admin: 'admin' }

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :source_accounts, dependent: :destroy
  has_many :invest_accounts, dependent: :destroy
  has_many :invest_sets,     dependent: :destroy

  def current_invest_set
    invest_sets&.last
  end

  def last_source_account
    source_accounts&.last
  end

  def last_invest_account
    invest_accounts&.last
  end
end
