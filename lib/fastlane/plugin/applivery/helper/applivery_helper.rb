module Fastlane
  module Helper
    class AppliveryHelper
      # class methods that you define here become available in your action
      # as `Helper::AppliveryHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the applivery plugin helper!")
      end
    end
  end
end
