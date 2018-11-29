class Webhook < ApplicationRecord
  # TODO: After commit, shoud be check existing webhook on dwolla
  attribute :secret, :string, default: proc { SecureRandom.hex(64) }
  attribute :url, :string, default: proc { File.join("https://#{ENV['APPLICATION_HOST']}", 'webhooks') }

  validates :url, :secret, presence: true

  validates :url, uniqueness: true

  def dwolla_registered?
    uid.present? && link.present?
  end

  def active
    !paused
  end
end
