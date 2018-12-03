class InvestTransaction < ApplicationRecord
  STATUSES = %w[planned pending processed cancelled failed].freeze
  TYPES = %w[one_time periodical].freeze

  attribute :status, :string, default: STATUSES[0]
  attribute :amount, :decimal, default: InvestSet::MIN_AMOUNT

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  validates :investment_type, inclusion: { in: TYPES }
  validates :amount, numericality: { greater_than_or_equal_to: InvestSet::MIN_AMOUNT }

  validates :invest_set_id, presence: true

  belongs_to :invest_set

  has_one :source_account, through: :invest_set
  has_one :invest_account, through: :invest_set

  scope :for_cancelling, -> { where(status: %w[planned pending]) }

  scope :periodical, -> { where investment_type: 'periodical' }

  scope :periodical_will_processed, -> { periodical.where('will_processed_at <= ? ', Time.current) }

  delegate :currency, to: :source_account, allow_nil: true
  delegate :rel_min_balance, to: :invest_set, allow_nil: true
  delegate :frequency, to: :invest_set, allow_nil: true

  before_create :assign_iso_currency_code

  # INFO: Init after create if it is One Time transaction
  after_commit :init_dwolla_transaction!, on: :create, if: :one_time?

  def human_amount
    # TODO: Need optimize
    return 'N/A' if calc_amount_later?

    Money.new(amount * 100, iso_currency_code).format
  end

  def calc_amount_later?
    (planned? || cancelled?) &&
      investment_type == 'periodical' &&
      invest_set.frequency.in?(%w[lowest algo])
  end

  def human_processed_at
    processed_at || will_processed_at || created_at
  end

  def one_time?
    investment_type == 'one_time'
  end

  def can_be_cancelled?
    planned? || pending?
  end

  def processed!
    self.processed_at = Time.current
    super
  end

  def pending!
    super
    Mailer.transfer_was_initiated(self).deliver_later
  end

  def cancelled!
    return unless can_be_cancelled?

    if planned?
      self.cancelled_at = Time.current
      super
    elsif pending?
      CancelTransactionJob.perform_later(id: id)
    end
  end

  def correlation_id
    Digest::MD5.hexdigest "#{invest_set_id}-#{id}-#{amount}-#{iso_currency_code}"
  end

  def cancelled?
    cancelled_at && super
  end

  private

  def init_dwolla_transaction!
    InitTransactionJob.perform_later(id: id)
  end

  def assign_iso_currency_code
    self.iso_currency_code = currency.iso_code
  end
end
