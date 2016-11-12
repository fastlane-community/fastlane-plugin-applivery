module Fastlane
  module Helper
    class AppliveryHelper
      # class methods that you define here become available in your action
      # as `Helper::AppliveryHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the applivery plugin helper!")
      end

      def self.platform
        platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]
        if platform == :ios or platform.nil?
          return "ios"
        elsif platform == :android
          return "android"
        end
      end

      def self.add_integration_number
        integrationNumber = ENV["XCS_INTEGRATION_NUMBER"] # XCode Server 
        command = ""
        if !integrationNumber.nil?
          command += " -F buildNumber=\"#{integrationNumber}\""
        end
        return command
      end


      ### GIT Methods ###

      def self.is_git?
        Actions.sh('git rev-parse HEAD')
        return true
      rescue
        return false
      end

      def self.add_git_params
        command = ""
        if self.is_git?
          UI.message "Detected repo: git"
          gitBranch = Actions.git_branch
          gitCommit = Actions.sh('git rev-parse --short HEAD')
          gitMessage = Actions.last_git_commit_message
          
          command += " -F gitBranch=\"#{gitBranch}\""
          command += " -F gitCommit=\"#{gitCommit}\""
          command += " -F gitMessage=\"#{gitMessage}\""
          command += self.add_git_remote
          command += self.add_git_tag
        end
        return command
      end

      def self.add_git_tag
        gitTag = Actions.sh('git describe --abbrev=0 --tags')
        gitTagCommit = Actions.sh("git rev-list -n 1 --abbrev-commit #{gitTag}")
        gitCommit = Actions.sh('git rev-parse --short HEAD')
        if gitTagCommit == gitCommit
            return " -F gitTag=\"#{gitTag}\""
        end
        return ""
      rescue
        return ""
      end

      def self.add_git_remote
        gitRepositoryURL = Actions.sh('git config --get remote.origin.url')
        return " -F gitRepositoryURL=\"#{gitRepositoryURL}\""
      rescue
        return ""
      end

    end
  end
end
