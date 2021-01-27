# Fastlane Applivery plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-applivery)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-applivery.svg)](https://badge.fury.io/rb/fastlane-plugin-applivery)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-applivery`, add it to your project by running:

```bash
fastlane add_plugin applivery
```

## About Applivery.com

With [Applivery.com](https://www.applivery.com) you can easily distribute your iOS and Android Apps throughout a customizable platform with no need of your users have to be registered on it.

**The main purpose of this plugin is to upload a new iOS or Android build to [Applivery.com](https://www.applivery.com).**

If you usually use Fastlane tools to automate the most common development tasks now you can start using out Fastlane Plugin to easily deploy new iOS and Android versions of your Apps to Applivery and close your development the cycle: Build, Test & deploy like a pro!

This **fastlane** plugin will also help you to have more context about the build, attaching and displaying the most relevant information: Direct link to the repository(GitHub & Bitbucket), commit hash, Branch, Tag, etc:

<!--![List of builds](http://www.applivery.com/wp-content/uploads/2016/08/BuildsList.png)-->
<!--![Build details](http://www.applivery.com/wp-content/uploads/2016/08/BuilInfo.png)-->

## Examples

Below you'll find some basic examples about how to **build** a new iOS or Android App and automatically **deploy** it into Applivery.com

### iOS App build and deploy
Next you'll find a `lane` with two steps: `gym()` that will build the iOS App and `applivery()` that will take care about the deployment.

```ruby
lane :applivery_ios do
  gym(
    scheme: "YOUR_APP_SCHEME",        # Your App Scheme
    export_method: 'enterprise')      # Choose between: enterprise or ad-hoc
  applivery(
    app_token: "YOUR_APP_TOKEN")      # Your Applivery App Token
end
```

### Android App build and deploy
Next you'll find a `lane` with two steps: `gradle()` that will build the Android App and `applivery()` that will take care about the deployment.

```ruby
lane :applivery_android do
  gradle(task: "assembleRelease")
  applivery(
    app_token: "YOUR_APP_TOKEN")        # Your Applivery App Token
end
```

Please check out the [example `Fastfile`](fastlane/Fastfile) to see additional examples of how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`. 

## Additional Parameters
The above examples are the most simple configuration you can have but you can add additional parameters to fully customize the deployment process. They are:

| Param                    | Description                          | Mandatory | Values       |
|--------------------------|--------------------------------------|-----------|--------------|
| `app_token`              | Applivery App Token                  | YES       | string -> Available in the App Settings |
| `name`                   | Applivery Build name                 | NO        | string-> i.e.: "RC 1.0"       |
| `notify_collaborators`   | Notify Collaborators after deploy    | NO        | booletan -> i.e.: rue / false |
| `notify_employees`       | Notify Employees after deploy        | NO        | booletan -> i.e.: true / false |
| `notify_message`         | Notification message                 | NO        | string -> i.e.: "Enjoy the new version!" |
| `changelog`              | Release notes                        | NO        | string -> i.e.: "Bug fixing"       |
| `tags`                   | Tags to identify the build           | NO        | string -> comma separated. i.e.: "RC1, QA" |
| `build_path`             | Build path to the APK / IPA file     | NO        | string -> by default it takes the IPA/APK build path |

## Shared Value
Once your build is uploaded successfuly, the new generated build ID is provided by a Shared Value `APPLIVERY_BUILD_ID` that can be accesed in your lane with `lane_context[SharedValues::APPLIVERY_BUILD_ID]`

Example:

```ruby
lane :applivery_ios do
  gym(
    scheme: "YOUR_APP_SCHEME",        # Your App Scheme
    export_method: 'enterprise')      # Choose between: enterprise or ad-hoc
  applivery(
    app_token: "YOUR_APP_TOKEN"       # Your Applivery App Token)
  puts "BUILD ID: #{lane_context[SharedValues::APPLIVERY_BUILD_ID]}"
end
```

You could use this id to open your build information in applivery like:

```
https://dashboard.applivery.io/apps/apps/{YOUR_APP_SLUG}/builds?id={THIS_BUILD_ID}
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use 
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository or contact us at [support@applivery.com](mailto:support@applivery.com)

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
