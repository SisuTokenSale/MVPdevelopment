class WebhookService
  STATUS_MAP = {
    customer: {
      created: %w[customer_created],
      verify_needed: %w[customer_verification_document_needed customer_reverification_needed],
      verify_uploaded: %w[customer_verification_document_uploaded],
      verify_failed: %w[customer_verification_document_failed],
      verify_approved: %w[customer_verification_document_approved],
      verified: %w[customer_verified],
      suspended: %w[customer_suspended],
      activated: %w[customer_activated],
      deactivated: %w[customer_deactivated]
    },
    funding_source: {
      added: %w[customer_funding_source_added customer_microdeposits_added],
      removed: %w[customer_funding_source_removed],
      verified: %w[customer_funding_source_verified],
      unverified: %w[customer_funding_source_unverified],
      negative: %w[customer_funding_source_negative],
      updated: %w[customer_funding_source_updated]
    },
    invest_transaction: {
      pending: %w[customer_bank_transfer_created customer_transfer_created],
      processed: %w[customer_bank_transfer_completed customer_transfer_completed],
      cancelled: %w[customer_bank_transfer_cancelled customer_transfer_cancelled],
      failed: %w[customer_bank_transfer_failed customer_transfer_failed customer_bank_transfer_creation_failed]
    }
  }.freeze

  attr_reader :webhook, :request_signature

  def initialize(opts = {})
    raise(ArgumentError, 'Webhook data required!') unless opts[:webhook]

    raise(ArgumentError, 'Signature required!') unless opts[:request_signature]

    @webhook = opts[:webhook]
    @request_signature = opts[:request_signature]
    verify_signature!
  end

  def create_event!
    raise(StandardError, 'Webhook already processed!') if Event.find_by(uid: webhook[:id])

    Event.create!(
      link: webhook[:_links][:self][:href],
      resource_id: webhook[:resourceId],
      topic: object_scope[:topic],
      object_class: object_scope[:object_class],
      status: object_scope[:status]
    )
  end

  def object_scope
    @object_scope ||= self.class.scope_by_topic(webhook[:topic]) || {}
  end

  class << self
    def topics
      @topics ||= STATUS_MAP.inject([]) { |memo, (_type, status)| memo << status.values }.flatten
    end

    def scope_by_topic(topic)
      return unless topic.in?(topics)

      stack = STATUS_MAP.detect do |_type, statuses|
        statuses.detect { |_status, topics| topic.in?(topics) }
      end

      {
        object_class: stack.first.to_s.classify,
        status: stack.second.detect { |_k, topics| topic.in?(topics) }.first.to_s,
        topic: topic
      }
    end
  end

  private

  def verify_signature!
    raise(StandardError, 'Webhook not registered!') unless DwollaWebhook.current&.secret

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), DwollaWebhook.current&.secret, webhook.to_json)

    raise(StandardError, 'Invalid signature!') unless Rack::Utils.secure_compare(signature, request_signature)
  end
end
