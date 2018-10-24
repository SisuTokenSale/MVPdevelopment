class User < ApplicationRecord
  enum role: { user: 'user', admin: 'admin' }

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :admin_set_by, class_name: 'User', foreign_key: :admin_set_by_id, optional: true
  has_many :source_accounts, dependent: :destroy
  has_many :invest_accounts, dependent: :destroy
  has_many :invest_sets,     dependent: :destroy
  has_many :set_admins, class_name: 'User', foreign_key: :admin_set_by_id

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
