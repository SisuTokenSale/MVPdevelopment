require 'rails_helper'

describe WebhooksController, type: :controller do
  let(:body) { build_dwolla_event_params }
  let(:signature) { build_dwolla_signature(body) }
  let!(:dwolla_webhook) { create :dwolla_webhook }

  describe '#create' do
    it 'returns http 201 if valid sign' do
      request.env['HTTP_X_REQUEST_SIGNATURE_SHA_256'] = signature
      request.env['CONTENT_TYPE'] = 'application/json'
      post :create, body: body.to_json
      expect(response).to have_http_status(:success)
    end

    it 'returns http 422 unprocessible_entity no content if invalid sign' do
      request.env['HTTP_X_REQUEST_SIGNATURE_SHA_256'] = 'invalidsignature'
      request.env['CONTENT_TYPE'] = 'application/json'

      post :create, body: { webhook: body }.to_json
      expect(response).to have_http_status(422)
      expect(response.body).to eq({ error: 'Invalid signature!' }.to_json)
    end

    it 'returns http 422 unprocessible_entity if sign is blank' do
      request.env['CONTENT_TYPE'] = 'application/json'
      post :create, body: { webhook: body }.to_json
      expect(response).to have_http_status(422)
      expect(response.body).to eq({ error: 'Signature required!' }.to_json)
    end
  end
end
