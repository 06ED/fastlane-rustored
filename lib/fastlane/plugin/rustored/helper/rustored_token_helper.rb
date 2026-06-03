require 'fastlane_core/ui/ui'
require 'base64'
require 'json'
require 'openssl'
require 'time'
require 'faraday'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class RustoredTokenHelper
      BASE_URL = 'https://public-api.rustore.ru/public'

      def self.client
        @client ||= Faraday.new(url: BASE_URL) do |f|
          f.request(:json)
          f.response(:json)
        end
      end

      def self.gen_token_signature(key_id:, private_key:, timestamp:)
        private_key_pem = Base64.decode64(private_key)
        rsa_private_key = OpenSSL::PKey::RSA.new(private_key_pem)

        message_to_sign = key_id + timestamp

        digest = OpenSSL::Digest.new('SHA512')
        signature_bytes = rsa_private_key.sign(digest, message_to_sign)
        Base64.strict_encode64(signature_bytes)
      end

      def self.get_token(key_id:, private_key:)
        timestamp = Time.now.utc.iso8601(3)
        sig = gen_token_signature(key_id: key_id, private_key: private_key, timestamp: timestamp)

        response = client.post('/auth') do |req|
          req.body = {
            keyId: key_id,
            signature: sig,
            timestamp: timestamp
          }
        end

        if response.success? && response.body['code'] == 'OK'
          response.body['body']['jwe']
        else
          UI.error("Failed to get token: #{response.status} - #{response.body['message']}")
          nil
        end
      end
    end
  end
end
