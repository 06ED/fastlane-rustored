require 'fastlane/action'
require 'fastlane_core/configuration/config_item'

require_relative '../helper/rustored_helper'
require_relative '../helper/rustored_options'

module Fastlane
  module Actions
    class RustoredPublishAabAction < Action
      def self.run(params)
        Fastlane::Helper::RustoredHelper.publish_aab(
          token: params[:token],
          package_name: params[:package_name],
          version_id: params[:version_id],
          aab_path: params[:aab_path]
        )
      end

      def self.description
        "Publish an AAB file to RuStore"
      end

      def self.authors
        ["06ED"]
      end

      def self.details
        "Uploads an Android App Bundle to an existing RuStore app version."
      end

      def self.available_options
        Fastlane::Helper::RustoredOptions.common_options + [
          FastlaneCore::ConfigItem.new(
            key: :aab_path,
            env_name: "RUSTORE_AAB_PATH",
            description: "Path to the AAB file you want to publish",
            optional: false,
            type: String
          )
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
