class InvestTransaction < ApplicationRecord
  STATUSES = %w[planned pending processed cancelled failed].freeze

  attribute :status, :string, default: STATUSES[0]
  attribute :amount, :decimal, default: InvestSet::MIN_AMOUNT

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :amount, numericality: { greater_than_or_equal_to: InvestSet::MIN_AMOUNT }

  validates :invest_set_id, presence: true

  belongs_to :invest_set

  has_one :source_account, through: :invest_set
  has_one :invest_account, through: :invest_set

  delegate :currency, to: :source_account, allow_nil: true

  before_create :assign_iso_currency_code

  def human_amount
    Money.new(amount * 100, iso_currency_code).format
  end

  private

  def assign_iso_currency_code
    self.iso_currency_code = currency.iso_code
  end
end
