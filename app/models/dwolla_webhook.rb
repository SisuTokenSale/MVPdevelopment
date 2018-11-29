class DwollaWebhook < Webhook
  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  after_commit :init_dwolla_webhook!, on: :create, unless: :dwolla_registered?

  after_commit :remove_dwolla_webhook!, on: :destroy, if: :dwolla_registered?

  private

  def init_dwolla_webhook!
    DwollaInitWebhookJob.perform_later(id: id)
  end

  def remove_dwolla_webhook!
    DwollaRemoveWebhookJob.perform_later(link: link)
  end
end
