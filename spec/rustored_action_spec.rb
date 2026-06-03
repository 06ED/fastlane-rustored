describe Fastlane::Actions::RustoredAction do
  describe '#run' do
    it 'publishes an aab as a legacy alias' do
      params = {
        token: 'token',
        package_name: 'com.example.app',
        version_id: '1',
        aab_path: 'app.aab'
      }

      expect(Fastlane::UI).to receive(:important)
      expect(Fastlane::Helper::RustoredHelper).to receive(:publish_aab).with(params)

      Fastlane::Actions::RustoredAction.run(params)
    end
  end
end

describe Fastlane::Actions::RustoredPublishAabAction do
  describe '#run' do
    it 'publishes an aab' do
      params = {
        token: 'token',
        package_name: 'com.example.app',
        version_id: '1',
        aab_path: 'app.aab'
      }

      expect(Fastlane::Helper::RustoredHelper).to receive(:publish_aab).with(params)

      Fastlane::Actions::RustoredPublishAabAction.run(params)
    end
  end
end

describe Fastlane::Actions::RustoredPublishApkAction do
  describe '#run' do
    it 'publishes an apk' do
      params = {
        token: 'token',
        package_name: 'com.example.app',
        version_id: '1',
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: 'app.apk'
      }

      expect(Fastlane::Helper::RustoredHelper).to receive(:publish_apk).with(params)

      Fastlane::Actions::RustoredPublishApkAction.run(params)
    end
  end
end
