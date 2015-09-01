#
# Be sure to run `pod lib lint MessagesUIKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MessagesUIKit"
  s.version          = "0.1.5"
  s.summary          = "UIKit for Messaging. UI is similar to WeChat."
  s.description      = <<-DESC
                       UIKit for Messaging. UI is similar to WeChat. You can custome most of the view.
                       DESC
  s.homepage         = "https://github.com/iException/MessagesUIKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "hyice" => "hy_ice719@163.com" }
  s.source           = { :git => "https://github.com/iException/MessagesUIKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
        'MessagesUIKit' => ['Pod/Assets/*.{jpg,png,xib,plist}']
  }

  s.dependency 'SDWebImage', '3.7.2'
end
