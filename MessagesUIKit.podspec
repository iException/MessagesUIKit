Pod::Spec.new do |s|
  s.name             = "MessagesUIKit"
  s.version          = "0.1.8"
  s.summary          = "UIKit for Messaging. UI is similar to WeChat."
  s.description      = <<-DESC
                       UIKit for Messaging. UI is similar to WeChat. You can custome most of the view.
                       DESC
  s.homepage         = "https://github.com/iException/MessagesUIKit"
  s.license          = 'MIT'
  s.author           = { "hyice" => "hy_ice719@163.com" }
  s.source           = { :git => "https://github.com/iException/MessagesUIKit.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MessagesUIKit' => ['Pod/Assets/*.{jpg,png,plist}']
  }
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'TTTAttributedLabel', '~> 2.0'
  s.dependency 'SDWebImage', '~> 3.8'
end
