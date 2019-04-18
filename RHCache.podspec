#
# Be sure to run `pod lib lint RHCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RHCache'
  s.version          = '0.1.1'
  s.summary          = 'Swift 缓存'

  s.description      = <<-DESC
  Swift缓存封装
                       DESC

  s.homepage         = 'https://github.com/495929699/RHCache'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rongheng' => '495929699g@gmail.com' }
  s.source           = { :git => 'https://github.com/495929699/RHCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.cocoapods_version = '>=1.6.0'

  s.source_files = 'RHCache/Classes/**/*.swift'
  
end
