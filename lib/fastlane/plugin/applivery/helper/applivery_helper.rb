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

      def self.get_base_domain(tenant = nil)
        default_domain = "applivery.io"
        return default_domain if tenant.nil? || tenant.strip.empty?
        return tenant if tenant.include?(".")
        return "#{tenant}.#{default_domain}"
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

      def self.git_branch
        return Actions.git_branch
      rescue
        return ""
      end

      def self.git_commit
        return `git rev-parse --short HEAD`
      rescue
        return ""
      end

      def self.git_message
        return Actions.last_git_commit_message
      rescue
        return ""
      end

      def self.add_git_remote
        return `git config --get remote.origin.url`
      rescue
        return ""
      end

      def self.git_tag
        gitTag = `git describe --abbrev=0 --tags`
        gitTagCommit = `git rev-list -n 1 --abbrev-commit '#{gitTag.strip}'`
        gitCommit = `git rev-parse --short HEAD`
        return gitTag if gitTagCommit == gitCommit
        return ""
      rescue
        return ""
      end

      def self.parse_error(error)
        if error
          case error["code"]
          when 5006
            UI.user_error! "Upload fail. The build path seems to be wrong or file is invalid"
          when 4004
            UI.user_error! "The app_token is not valid. Please, go to your app settings and doble-check the integration tokens"
          when 4002
            UI.user_error! "The app_token is empty. Please, go to your app Settings->Integrations to generate a token"
          else
            UI.user_error! "Upload fail. [#{error["code"]}]: #{error["message"]}"
          end
        else
          UI.crash! "Upload fails unexpectedly. [#{response.status}]"
        end
      end

    end
  end
end
