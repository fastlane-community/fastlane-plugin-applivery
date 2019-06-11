module Fastlane
  module Actions
    class AppliveryAction < Action

      def self.run(params)
        appToken = params[:appToken]
        name = params[:name]
        changelog = Helper::AppliveryHelper.escape(params[:changelog])
        notifyMessage = Helper::AppliveryHelper.escape(params[:notifyMessage])
        tags = params[:tags]
        build_path = params[:build_path]
        notifyCollaborators = params[:notifyCollaborators]
        notifyEmployees = params[:notifyEmployees]

        command = "curl \"https://dashboard.applivery.com/api/builds\""
        command += " -H \"Authorization: bearer #{appToken}\""
        command += " -F versionName=\"#{name}\""
        command += " -F changelog=\"#{notes}\""
        command += " -F notifyCollaborators=#{notifyCollaborators}"
        command += " -F notifyEmployees=#{notifyEmployees}"
        command += " -F tags=\"#{tags}\""
        command += " -F notifyMessage=\"#{notifyMessage}\""
        command += " -F build=@\"#{build_path}\""
        command += " -F deployer.name=fastlane"
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
        "Upload new iOS or Android build to Applivery"
      end

      def self.authors
        ["Alejandro Jimenez", "Cesar Trigo"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :appToken,
            env_name: "APPLIVERY_APP_TOKEN",
            description: "Your application identifier",
            optional: false,
            type: String),

          FastlaneCore::ConfigItem.new(key: :name,
            env_name: "APPLIVERY_BUILD_NAME",
            description: "Your build name",
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :changelog,
            env_name: "APPLIVERY_BUILD_CHANGELOG",
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

          FastlaneCore::ConfigItem.new(key: :notifyCollaborators,
            env_name: "APPLIVERY_NOTIFY_COLLABORATORS",
            description: "Send an email to your App Collaborators",
            default_value: true,
            optional: true,
            is_string: false),

          FastlaneCore::ConfigItem.new(key: :notifyEmployees,
            env_name: "APPLIVERY_NOTIFY_EMPLOYEES",
            description: "Send an email to your App Employees",
            default_value: true,
            optional: true,
            is_string: false),

          FastlaneCore::ConfigItem.new(key: :notifyMessage,
            env_name: "APPLIVERY_NOTIFY_MESSAGE",
            description: "Notification message to be sent along with email notifications",
            default_value: true,
            optional: true,
            is_string: false),

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
            appToken: "YOUR_APP_TOKEN")'
        ]
      end

    end
  end
end
