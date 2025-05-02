#
# Be sure to run `pod lib lint CallKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NERtcCallKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CallKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Netease/CallKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Netease' => 'cyn0544@corp.netease.com' }
  s.source           = { :git => 'https://github.com/Netease/CallKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.source_files = 'CallKit/Classes/**/*'

  s.vendored_frameworks = ['CallKit/Classes/*.framework']
  
  s.dependency 'NIMSDK_LITE', '>=9.2.5'
#  s.dependency 'NERtcSDK_Special', '4.6.102'
  s.dependency 'NERtcSDK/RtcBasic', '~>4.2.142'
  s.dependency 'YXAlog_iOS', '1.0.6'
  
  # s.resource_bundles = {
  #   'CallKit' => ['CallKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
