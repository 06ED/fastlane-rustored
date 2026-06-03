require 'fastlane/action'
require 'fastlane_core/configuration/config_item'

require_relative '../helper/rustored_helper'
require_relative '../helper/rustored_options'

module Fastlane
  module Actions
    class RustoredPublishApkAction < Action
      def self.run(params)
        Fastlane::Helper::RustoredHelper.publish_apk(
          token: params[:token],
          package_name: params[:package_name],
          version_id: params[:version_id],
          services_type: params[:services_type],
          is_main_apk: params[:is_main_apk],
          apk_path: params[:apk_path]
        )
      end

      def self.description
        "Publish an APK file to RuStore"
      end

      def self.authors
        ["06ED"]
      end

      def self.details
        "Uploads an APK to an existing RuStore app version."
      end

      def self.available_options
        Fastlane::Helper::RustoredOptions.common_options + [
          FastlaneCore::ConfigItem.new(
            key: :apk_path,
            env_name: "RUSTORE_APK_PATH",
            description: "Path to the APK file you want to publish",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :services_type,
            env_name: "RUSTORE_SERVICES_TYPE",
            description: "The APK services type",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :is_main_apk,
            env_name: "RUSTORE_IS_MAIN_APK",
            description: "Whether this APK is the main APK",
            optional: false,
            type: Boolean
          )
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
