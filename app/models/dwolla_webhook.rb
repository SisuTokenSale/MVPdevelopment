class DwollaWebhook < Webhook
  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  after_commit :init_dwolla_webhook!, on: :create, unless: :dwolla_registered?

  private

  def init_dwolla_webhook!
    DwollaInitWebhookJob.process!(id: id)
  end
end
