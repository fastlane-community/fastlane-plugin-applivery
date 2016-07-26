describe Fastlane::Actions::AppliveryAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The applivery plugin is working!")

      Fastlane::Actions::AppliveryAction.run(nil)
    end
  end
end
