def build_dwolla_event_params(opts = {})
  opts[:uuid] ||= SecureRandom.uuid
  opts[:resource_id] ||= SecureRandom.uuid
  opts[:topic] ||= 'customer_transfer_created'
  {
    id: opts[:uuid],
    resourceId: opts[:resource_id],
    topic: opts[:topic],
    timestamp: '2018-11-23T18:18:50.036Z',
    _links: {
      self: {
        href: "https://api-sandbox.dwolla.com/events/#{opts[:uuid]}"
      },
      account: {
        href: 'https://api-sandbox.dwolla.com/accounts/5c69fe7f-9b5c-4d40-9899-881ba7d6a5eb'
      },
      resource: {
        href: "https://api-sandbox.dwolla.com/transfers/#{opts[:resource_id]}"
      },
      customer: {
        href: 'https://api-sandbox.dwolla.com/customers/6fd736d9-d191-4910-9230-9ef7eb43ce6a'
      }
    },
    created: '2018-11-23T18:18:50.036Z'
  }
end

def build_dwolla_signature(payload)
  return if payload.blank?

  OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), DwollaWebhook.current&.secret, payload&.to_json)
end
