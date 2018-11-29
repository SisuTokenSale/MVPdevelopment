class Webhook < ApplicationRecord
  WEBHOOK_URL = File.join("https://#{ENV['APPLICATION_HOST']}", 'webhooks').freeze
  # TODO: After commit, shoud be check existing webhook on dwolla
  attribute :secret, :string, default: proc { SecureRandom.hex(64) }
  attribute :url, :string, default: WEBHOOK_URL

  validates :url, :secret, presence: true

  validates :url, uniqueness: true

  def dwolla_registered?
    uid.present? && link.present?
  end

  class << self
    def current
      find_by url: WEBHOOK_URL
    end
  end

  def active?
    !paused
  end

  def current?
    url == WEBHOOK_URL
  end
end
