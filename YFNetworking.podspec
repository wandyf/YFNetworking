#
# Be sure to run `pod lib lint YFNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YFNetworking'
  s.version          = '0.1.0'
  s.summary          = '基于AFNEtworking的网络层封装.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        基于AFNEtworking的网络层封装.
                       DESC

  s.homepage         = 'https://github.com/wandyf/YFNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WangYunFeng' => 'dev.yunfeng.wang@outlook.com' }
  s.source           = { :git => 'https://github.com/wandyf/YFNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.subspec 'Core' do |ss|
  ss.source_files = 'YFNetworking/Core/*.{h,m}'
  ss.public_header_files = 'YFNetworking/Core/*.h'
  end
  
  s.dependency 'AFNetworking', '4.0.1'
    
end
