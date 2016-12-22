module Fastlane
  module Actions
    class AppliveryAction < Action

      def self.run(params)
        app_id = params[:app_id]
        api_key = params[:api_key]
        name = params[:name]
        notes = params[:notes]
        tags = params[:tags]
        build_path = params[:build_path]
        notify = params[:notify]
        autoremove = params[:autoremove]
        os = Helper::AppliveryHelper.platform

        command = "curl \"https://dashboard.applivery.com/api/builds\""
        command += " -H \"Authorization: #{api_key}\""
        command += " -F app=\"#{app_id}\""
        command += " -F versionName=\"#{name}\""
        command += " -F notes=\"#{notes}\""
        command += " -F notify=#{notify}"
        command += " -F autoremove=#{autoremove}"
        command += " -F os=#{os}"
        command += " -F tags=\"#{tags}\""
        command += " -F deployer=fastlane"
        command += " -F package=@\"#{build_path}\""
        command += Helper::AppliveryHelper.add_integration_number
        command += Helper::AppliveryHelper.add_git_params

        Actions.sh(command)
      end

      def self.build_path
        platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]

        if platform == :ios
          return Actions.lane_context[SharedValues::IPA_OUTPUT_PATH]
        else
          return Actions.lane_context[Actions::SharedValues::GRADLE_APK_OUTPUT_PATH]
        end
      end

      def self.description
        "Upload new build to Applivery"
      end

      def self.authors
        ["Alejandro Jimenez"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_id,
            env_name: "APPLIVERY_APP_ID",
            description: "Your application identifier",
            optional: false,
            type: String),

          FastlaneCore::ConfigItem.new(key: :api_key,
            env_name: "APPLIVERY_API_KEY",
            description: "Your developer key",
            optional: false,
            type: String),

          FastlaneCore::ConfigItem.new(key: :name,
            env_name: "APPLIVERY_BUILD_NAME",
            description: "Your build name",
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :notes,
            env_name: "APPLIVERY_BUILD_NOTES",
            description: "Your build notes",
            default_value: "Uploaded automatically with fastlane plugin",
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :tags,
            env_name: "APPLIVERY_BUILD_TAGS",
            description: "Your build tags",
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :build_path,
            env_name: "APPLIVERY_BUILD_PATH",
            description: "Your build path",
            default_value: self.build_path,
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :notify,
            env_name: "APPLIVERY_NOTIFY",
            description: "Send an email to your users",
            default_value: true,
            optional: true,
            is_string: false),

          FastlaneCore::ConfigItem.new(key: :autoremove,
            env_name: "APPLIVERY_AUTOREMOVE",
            description: "Automatically remove your application's oldest build",
            default_value: true,
            optional: true,
            is_string: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        
        [:ios, :android].include?(platform)
        true
      end

      def self.category
        :beta
      end

      def self.example_code
        [
          'applivery(
            app_id: "YOUR_APP_ID",
            api_key: "YOUR_APP_SECRET")'
        ]
      end

    end
  end
end
