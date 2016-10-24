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
        gitBranch = Actions.git_branch
        commitHash = Actions.sh('git rev-parse --short HEAD')
        gitMessage = Actions.last_git_commit_message
        gitRepositoryURL = Actions.sh('git config --get remote.origin.url')

        platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]

        if platform == :ios or platform.nil?
          os = "ios"
        end

        if platform == :android
          os = "android"
        end

        command = "curl \"https://dashboard.applivery.com/api/builds\""
        command += " -H \"Authorization: #{api_key}\""
        command += " -F app=\"#{app_id}\""
        command += " -F versionName=\"#{name}\""
        command += " -F notes=\"#{notes}\""
        command += " -F notify=#{notify}"
        command += " -F os=#{os}"
        command += " -F tags=\"#{tags}\""
        command += " -F deployer=fastlane"
        command += " -F gitBranch=\"#{gitBranch}\""
        command += " -F gitCommit=\"#{commitHash}\""
        command += " -F gitMessage=\"#{gitMessage}\""
        command += " -F gitRepositoryURL=\"#{gitRepositoryURL}\""
        command += " -F package=@\"#{build_path}\""

        Actions.sh(command)
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
            optional: false,
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
            default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH],
            optional: true,
            type: String),

          FastlaneCore::ConfigItem.new(key: :notify,
            env_name: "APPLIVERY_NOTIFY",
            description: "Send an email to your users",
            default_value: true,
            optional: true)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        
        [:ios, :android].include?(platform)
        true
      end
    end
  end
end
