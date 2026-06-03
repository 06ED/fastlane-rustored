describe Fastlane::Actions::RustoredPublishAabAction do
  describe '#run' do
    it 'publishes an aab' do
      params = {
        key_id: 'key_id',
        private_key: 'private_key',
        package_name: 'com.example.app',
        version_id: 1,
        aab_path: 'app.aab'
      }

      expect(Fastlane::Helper::RustoredHelper).to receive(:publish_aab).with(
        key_id: 'key_id',
        private_key: 'private_key',
        package_name: 'com.example.app',
        version_id: 1,
        aab_path: 'app.aab'
      )

      Fastlane::Actions::RustoredPublishAabAction.run(params)
    end
  end

  describe 'metadata' do
    it 'describes the action' do
      expect(described_class.description).to eq('Publish an AAB file to RuStore')
      expect(described_class.authors).to eq(['06ED'])
      expect(described_class.details).to eq('Uploads an Android App Bundle to an existing RuStore app version.')
      expect(described_class.available_options.map(&:key)).to include(:key_id, :private_key, :package_name, :version_id, :aab_path)
      expect(described_class.is_supported?(:android)).to eq(true)
      expect(described_class.is_supported?(:ios)).to eq(false)
    end
  end
end

describe Fastlane::Actions::RustoredPublishApkAction do
  describe '#run' do
    it 'publishes an apk' do
      params = {
        key_id: 'key_id',
        private_key: 'private_key',
        package_name: 'com.example.app',
        version_id: 1,
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: 'app.apk'
      }

      expect(Fastlane::Helper::RustoredHelper).to receive(:publish_apk).with(
        key_id: 'key_id',
        private_key: 'private_key',
        package_name: 'com.example.app',
        version_id: 1,
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: 'app.apk'
      )

      Fastlane::Actions::RustoredPublishApkAction.run(params)
    end
  end

  describe 'metadata' do
    it 'describes the action' do
      expect(described_class.description).to eq('Publish an APK file to RuStore')
      expect(described_class.authors).to eq(['06ED'])
      expect(described_class.details).to eq('Uploads an APK to an existing RuStore app version.')
      expect(described_class.available_options.map(&:key)).to include(
        :key_id,
        :private_key,
        :package_name,
        :version_id,
        :apk_path,
        :services_type,
        :is_main_apk
      )
      expect(described_class.is_supported?(:android)).to eq(true)
      expect(described_class.is_supported?(:ios)).to eq(false)
    end
  end
end
