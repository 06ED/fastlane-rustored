require 'json'
require 'tempfile'
require 'uri'

describe Fastlane::Helper::RustoredHelper do
  let(:key_id) { 'key-id' }
  let(:private_key) { 'private-key' }
  let(:package_name) { 'com.example.app' }
  let(:version_id) { 1 }

  def upload_file
    file = Tempfile.new('rustored-upload')
    file.write('artifact')
    file.close
    file
  end

  def multipart_client(stubs)
    Faraday.new(url: described_class::BASE_URL) do |f|
      f.request(:multipart)
      f.response(:json)
      f.adapter(:test, stubs)
    end
  end

  describe '.client' do
    it 'builds a faraday client for the publish api' do
      described_class.instance_variable_set(:@client, nil)

      expect(described_class.client).to be_a(Faraday::Connection)
      expect(described_class.client.url_prefix.to_s).to eq(described_class::BASE_URL)
    end
  end

  describe '.publish_aab' do
    it 'publishes an aab with a generated public token' do
      file = upload_file

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/application/#{package_name}/version/#{version_id}/aab") do |env|
          expect(env.request_headers['Public-Token']).to eq('jwe-token')
          expect(env.request_headers['Content-Type']).to include('multipart/form-data')

          [
            200,
            { 'Content-Type' => 'application/json' },
            { code: 'OK' }.to_json
          ]
        end
      end

      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).with(
        key_id: key_id,
        private_key: private_key
      ).and_return('jwe-token')
      allow(described_class).to receive(:client).and_return(multipart_client(stubs))
      allow(Fastlane::UI).to receive(:success)

      described_class.publish_aab(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        aab_path: file.path
      )

      expect(Fastlane::UI).to have_received(:success).with('AAB published successfully!')
      stubs.verify_stubbed_calls
    ensure
      file&.unlink
    end

    it 'raises when token cannot be obtained' do
      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).and_return(nil)
      allow(Fastlane::UI).to receive(:user_error!)

      described_class.publish_aab(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        aab_path: 'app.aab'
      )

      expect(Fastlane::UI).to have_received(:user_error!).with('Cannot publish AAB without a valid token')
    end

    it 'reports publish failures' do
      file = upload_file

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/application/#{package_name}/version/#{version_id}/aab") do
          [
            500,
            { 'Content-Type' => 'application/json' },
            { code: 'ERROR', message: 'Server error' }.to_json
          ]
        end
      end

      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).and_return('jwe-token')
      allow(described_class).to receive(:client).and_return(multipart_client(stubs))
      allow(Fastlane::UI).to receive(:error)

      described_class.publish_aab(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        aab_path: file.path
      )

      expect(Fastlane::UI).to have_received(:error).with('Failed to publish AAB: 500 - Server error')
      stubs.verify_stubbed_calls
    ensure
      file&.unlink
    end
  end

  describe '.publish_apk' do
    it 'publishes an apk with query params and a generated public token' do
      file = upload_file

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/application/#{package_name}/version/#{version_id}/apk") do |env|
          query = URI.decode_www_form(env.url.query).to_h

          expect(env.request_headers['Public-Token']).to eq('jwe-token')
          expect(env.request_headers['Content-Type']).to include('multipart/form-data')
          expect(query).to eq(
            'servicesType' => 'Unknown',
            'isMainApk' => 'true'
          )

          [
            200,
            { 'Content-Type' => 'application/json' },
            { code: 'OK' }.to_json
          ]
        end
      end

      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).with(
        key_id: key_id,
        private_key: private_key
      ).and_return('jwe-token')
      allow(described_class).to receive(:client).and_return(multipart_client(stubs))
      allow(Fastlane::UI).to receive(:success)

      described_class.publish_apk(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: file.path
      )

      expect(Fastlane::UI).to have_received(:success).with('APK published successfully!')
      stubs.verify_stubbed_calls
    ensure
      file&.unlink
    end

    it 'raises when token cannot be obtained' do
      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).and_return(nil)
      allow(Fastlane::UI).to receive(:user_error!)

      described_class.publish_apk(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: 'app.apk'
      )

      expect(Fastlane::UI).to have_received(:user_error!).with('Cannot publish APK without a valid token')
    end

    it 'reports publish failures' do
      file = upload_file

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/application/#{package_name}/version/#{version_id}/apk") do
          [
            500,
            { 'Content-Type' => 'application/json' },
            { code: 'ERROR', message: 'Server error' }.to_json
          ]
        end
      end

      allow(Fastlane::Helper::RustoredTokenHelper).to receive(:get_token).and_return('jwe-token')
      allow(described_class).to receive(:client).and_return(multipart_client(stubs))
      allow(Fastlane::UI).to receive(:error)

      described_class.publish_apk(
        key_id: key_id,
        private_key: private_key,
        package_name: package_name,
        version_id: version_id,
        services_type: 'Unknown',
        is_main_apk: true,
        apk_path: file.path
      )

      expect(Fastlane::UI).to have_received(:error).with('Failed to publish APK: 500 - Server error')
      stubs.verify_stubbed_calls
    ensure
      file&.unlink
    end
  end
end
