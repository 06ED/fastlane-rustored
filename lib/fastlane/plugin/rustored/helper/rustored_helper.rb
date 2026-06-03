require 'fastlane_core/ui/ui'
require 'faraday'
require_relative 'rustored_token_helper'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class RustoredHelper
      BASE_URL = 'https://public-api.rustore.ru/public/v1'

      def self.client
        @client ||= Faraday.new(url: BASE_URL) do |f|
          f.request(:multipart)
          f.response(:json)
        end
      end

      def self.publish_aab(key_id:, private_key:, package_name:, version_id:, aab_path:)
        UI.message("Publishing AAB to Rustore...")

        token = RustoredTokenHelper.get_token(key_id: key_id, private_key: private_key)
        if token.nil?
          UI.user_error!("Cannot publish AAB without a valid token")
          return
        end

        response = client.post("/application/#{package_name}/version/#{version_id}/aab") do |req|
          req.headers['Public-Token'] = token
          req.body = {
            file: Faraday::UploadIO.new(aab_path, 'application/octet-stream')
          }
        end

        if response.success? && response.body['code'] == 'OK'
          UI.success("AAB published successfully!")
        else
          UI.error("Failed to publish AAB: #{response.status} - #{response.body['message']}")
        end
      end

      def self.publish_apk(key_id:, private_key:, package_name:, version_id:, services_type:, is_main_apk:, apk_path:)
        UI.message("Publishing APK to Rustore...")

        token = RustoredTokenHelper.get_token(key_id: key_id, private_key: private_key)
        if token.nil?
          UI.user_error!("Cannot publish APK without a valid token")
          return
        end

        response = client.post("/application/#{package_name}/version/#{version_id}/apk") do |req|
          req.headers['Public-Token'] = token

          req.params['servicesType'] = services_type
          req.params['isMainApk'] = is_main_apk

          req.body = {
            file: Faraday::UploadIO.new(apk_path, 'application/octet-stream')
          }
        end

        if response.success? && response.body['code'] == 'OK'
          UI.success("APK published successfully!")
        else
          UI.error("Failed to publish APK: #{response.status} - #{response.body['message']}")
        end
      end
    end
  end
end
