# rustored

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-rustored)

Fastlane plugin for publishing Android builds to RuStore.

## Install

```bash
fastlane add_plugin rustored
```

## Actions

### `rustored_publish_aab`

Publishes an AAB file.

```ruby
rustored_publish_aab(
  token: ENV["RUSTORE_TOKEN"],
  package_name: "com.example.app",
  version_id: "123456",
  aab_path: "app/build/outputs/bundle/release/app-release.aab"
)
```

### `rustored_publish_apk`

Publishes an APK file.

```ruby
rustored_publish_apk(
  token: ENV["RUSTORE_TOKEN"],
  package_name: "com.example.app",
  version_id: "123456",
  apk_path: "app/build/outputs/apk/release/app-release.apk",
  services_type: "Unknown",
  is_main_apk: true
)
```

## Options

Shared:

| Option | Env | Required |
| --- | --- | --- |
| `token` | `RUSTORE_TOKEN` | yes |
| `package_name` | `RUSTORE_PACKAGE_NAME` | yes |
| `version_id` | `RUSTORE_VERSION_ID` | yes |

AAB:

| Option | Env | Required |
| --- | --- | --- |
| `aab_path` | `RUSTORE_AAB_PATH` | yes |

APK:

| Option | Env | Required |
| --- | --- | --- |
| `apk_path` | `RUSTORE_APK_PATH` | yes |
| `services_type` | `RUSTORE_SERVICES_TYPE` | no |
| `is_main_apk` | `RUSTORE_IS_MAIN_APK` | yes |

## Test

```bash
bundle exec rspec
bundle exec rubocop
```
