#
# Be sure to run `pod lib lint FBBClientService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  # 项目名称 七陌 客服
  s.name             = "FBBClientService"
  # 项目的版本号，通过项目git的tag标签进行对应，这里的标签代表的版本
  s.version          = "1.0.1"
  # 项目简单的描述信息
  s.summary          = "七陌客服UI组件"
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/nehzx/FBBClientService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '阿振' => '964190389@qq.com' }
  s.source           = { :git => 'https://github.com/nehzx/FBBClientService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '8.0'
  
  s.source_files = 'FBBClientService/Classes/**/*'
  s.libraries = "sqlite3", "z", "resolv"
  # 第三方或自己创建的 .Framework的名称
  s.vendored_frameworks = "FBBClientService/QMLineSDK.framework"
  # 第三方或自己创建的 .a静态库的名称
  s.vendored_libraries = "FBBClientService/Voice/libmp3lame.a"
  # CocoaPods会把这个库配置成static framework，同时支持Swift和Objective-C
  s.static_framework = true
  s.resource_bundles = {
    'FBBClientService' => ['FBBClientService/Assets/*']
  }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.prefix_header_contents = '#import "PrefixHeader.h"'
  
  s.dependency 'FMDB'
  s.dependency 'HappyDNS'
  s.dependency 'Qiniu'
  s.dependency 'JSONModel'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'
  s.dependency 'MJRefresh'
  s.dependency 'TZImagePickerController'
end
