class User < ApplicationRecord
  ROLES = %w[admin user].freeze

  attr_accessor :terms

  enum role: ROLES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :admin_set_by, class_name: 'User', foreign_key: :admin_set_by_id, optional: true, inverse_of: :set_admins
  has_one :profile, dependent: :destroy, inverse_of: :user
  has_many :source_accounts, dependent: :destroy
  has_many :invest_accounts, dependent: :destroy
  has_many :invest_sets,     dependent: :destroy
  has_many :set_admins, class_name: 'User', foreign_key: :admin_set_by_id,
                        dependent: :nullify, inverse_of: :admin_set_by

  validates :terms, acceptance: true

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
