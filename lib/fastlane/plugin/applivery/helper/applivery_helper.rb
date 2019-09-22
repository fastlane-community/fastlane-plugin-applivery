module Fastlane
  module Helper
    class AppliveryHelper
      # class methods that you define here become available in your action
      # as `Helper::AppliveryHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the applivery plugin helper!")
      end

      def self.escape(string)
        return URI.encode(string.sub(/@/, '\@'))
      end

      def self.platform
        platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]
        if platform == :ios or platform.nil?
          return "ios"
        elsif platform == :android
          return "android"
        end
      end

      def self.get_integration_number
        xcodeIntegrationNumber = ENV["XCS_INTEGRATION_NUMBER"] # XCode Server
        jenkinsIntegrationNumber = ENV["BUILD_NUMBER"] # Jenkins
        travisIntegrationNumber = ENV["TRAVIS_BUILD_NUMBER"] # Travis
        integrationNumber = ""
        
        if !xcodeIntegrationNumber.nil?
          integrationNumber += xcodeIntegrationNumber
        elsif !jenkinsIntegrationNumber.nil?
          integrationNumber += jenkinsIntegrationNumber
        elsif !travisIntegrationNumber.nil?
          integrationNumber += travisIntegrationNumber
        end

        return integrationNumber
      end


      ### GIT Methods ###

      def self.is_git?
        Actions.sh('git rev-parse HEAD')
        return true
      rescue
        return false
      end

      def self.git_branch
        return Actions.git_branch
      rescue
        return ""
      end

      def self.git_commit
        return Actions.sh('git rev-parse --short HEAD')
      rescue
        return "commit"
      end

      def self.git_message
        return Actions.last_git_commit_message
      rescue
        return ""
      end

      def self.add_git_remote
        return Actions.sh('git config --get remote.origin.url')
      rescue
        return ""
      end

      def self.git_tag
        gitTag = Actions.sh('git describe --abbrev=0 --tags')
        gitTagCommit = Actions.sh("git rev-list -n 1 --abbrev-commit #{gitTag}")
        gitCommit = Actions.sh('git rev-parse --short HEAD')
        if gitTagCommit == gitCommit
          return gitTag
        end
        return ""
      rescue
        return ""
      end

    end
  end
end
