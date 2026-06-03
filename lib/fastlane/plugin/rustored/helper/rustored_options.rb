require 'fastlane_core/configuration/config_item'

module Fastlane
  module Helper
    module RustoredOptions
      def self.common_options
        [
          FastlaneCore::ConfigItem.new(
            key: :token,
            env_name: "RUSTORE_TOKEN",
            description: "The token for authenticating with RuStore",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :package_name,
            env_name: "RUSTORE_PACKAGE_NAME",
            description: "The package name of the app you want to publish",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :version_id,
            env_name: "RUSTORE_VERSION_ID",
            description: "The version id of the app you want to publish",
            optional: false,
            type: Integer
          )
        ]
      end
    end
  end
end
