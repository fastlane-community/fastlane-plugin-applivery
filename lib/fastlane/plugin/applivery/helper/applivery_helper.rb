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

      def self.add_integration_number
        xcodeIntegrationNumber = ENV["XCS_INTEGRATION_NUMBER"] # XCode Server
        jenkinsIntegrationNumber = ENV["BUILD_NUMBER"] # Jenkins
        travisIntegrationNumber = ENV["TRAVIS_BUILD_NUMBER"] # Travis
        command = ""
        
        if !xcodeIntegrationNumber.nil?
          command += " -F deployer.info.buildNumber=\"#{xcodeIntegrationNumber}\""
        elsif !jenkinsIntegrationNumber.nil?
          command += " -F deployer.info.buildNumber=\"#{jenkinsIntegrationNumber}\""
        elsif !travisIntegrationNumber.nil?
          command += " -F deployer.info.buildNumber=\"#{travisIntegrationNumber}\""
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
          
          command += " -F deployer.info.branch=\"#{gitBranch}\""
          command += " -F deployer.info.commit=\"#{gitCommit}\""
          command += " -F deployer.info.commitMessage=\"#{self.escape(gitMessage)}\""
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
            return " -F deployer.info.tag=\"#{gitTag}\""
        end
        return ""
      rescue
        return ""
      end

      def self.add_git_remote
        gitRepositoryURL = Actions.sh('git config --get remote.origin.url')
        return " -F deployer.info.repositoryUrl=\"#{gitRepositoryURL}\""
      rescue
        return ""
      end

    end
  end
end
