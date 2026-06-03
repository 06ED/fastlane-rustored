require 'base64'
require 'json'
require 'openssl'
require 'time'

describe Fastlane::Helper::RustoredTokenHelper do
  let(:key_id) { 'key-id' }
  let(:rsa_key) { OpenSSL::PKey::RSA.new(2048) }
  let(:private_key) { Base64.strict_encode64(rsa_key.to_pem) }
  let(:timestamp) { '2026-06-03T10:20:30.000Z' }

  describe '.client' do
    it 'builds a faraday client for the auth api' do
      described_class.instance_variable_set(:@client, nil)

      expect(described_class.client).to be_a(Faraday::Connection)
      expect(described_class.client.url_prefix.to_s).to eq(described_class::BASE_URL)
    end
  end

  describe '.gen_token_signature' do
    it 'returns a base64 encoded RSA SHA512 signature for key id and timestamp' do
      signature = described_class.gen_token_signature(
        key_id: key_id,
        private_key: private_key,
        timestamp: timestamp
      )

      signature_bytes = Base64.strict_decode64(signature)
      digest = OpenSSL::Digest.new('SHA512')

      expect(rsa_key.public_key.verify(digest, signature_bytes, key_id + timestamp)).to eq(true)
    end
  end

  describe '.get_token' do
    before do
      allow(Time).to receive(:now).and_return(Time.utc(2026, 6, 3, 10, 20, 30))
    end

    it 'requests a token and returns the jwe value' do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/auth') do |env|
          request_body = JSON.parse(env.body)
          signature_bytes = Base64.strict_decode64(request_body['signature'])
          digest = OpenSSL::Digest.new('SHA512')

          expect(request_body['keyId']).to eq(key_id)
          expect(request_body['timestamp']).to eq(timestamp)
          expect(rsa_key.public_key.verify(digest, signature_bytes, key_id + timestamp)).to eq(true)

          [
            200,
            { 'Content-Type' => 'application/json' },
            { code: 'OK', body: { jwe: 'jwe-token' } }.to_json
          ]
        end
      end

      client = Faraday.new(url: described_class::BASE_URL) do |f|
        f.request(:json)
        f.response(:json)
        f.adapter(:test, stubs)
      end

      allow(described_class).to receive(:client).and_return(client)

      expect(described_class.get_token(key_id: key_id, private_key: private_key)).to eq('jwe-token')
      stubs.verify_stubbed_calls
    end

    it 'returns nil when auth fails' do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/auth') do
          [
            401,
            { 'Content-Type' => 'application/json' },
            { code: 'ERROR', message: 'Unauthorized' }.to_json
          ]
        end
      end

      client = Faraday.new(url: described_class::BASE_URL) do |f|
        f.request(:json)
        f.response(:json)
        f.adapter(:test, stubs)
      end

      allow(described_class).to receive(:client).and_return(client)
      allow(Fastlane::UI).to receive(:error)

      expect(described_class.get_token(key_id: key_id, private_key: private_key)).to be_nil
      expect(Fastlane::UI).to have_received(:error).with('Failed to get token: 401 - Unauthorized')
      stubs.verify_stubbed_calls
    end
  end
end
