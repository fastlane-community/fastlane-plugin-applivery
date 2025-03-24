describe Fastlane::Actions::AppliveryAction do
  describe '#run' do
    it 'should run the action' do
      Fastlane::Actions::AppliveryAction.run({
        app_token: ENV['APP_TOKEN'], 
        name: "Test Build",
        changelog: "This is a test build",
        tags: "test,fastlane",
        build_path: ENV['BUILD_PATH'],
        notify_collaborators: false,
        notify_employees: false,
        # notify_message: "New test build uploaded!",
        # filter: "test-group",
        # tenant: "mycompany"
      })
    end
  end
end
