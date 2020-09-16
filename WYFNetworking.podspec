
Pod::Spec.new do |s|
  s.name             = 'WYFNetworking'
  s.version          = '0.3.2'
  s.summary          = '基于AFNEtworking的网络层封装.'
  s.description      = <<-DESC
                        基于AFNEtworking的网络层封装,继承YFNetworking,
                        支持自定义HostURL和Base Paramaters,
                        支持自定义参数加密方法.
                       DESC

  s.homepage         = 'https://github.com/wandyf/YFNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WangYunFeng' => 'dev.yunfeng.wang@outlook.com' }
  s.source           = { :git => 'https://github.com/wandyf/YFNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.subspec 'Core' do |ss|
  ss.source_files = 'YFNetworking/Core/*.{h,m}'
  ss.public_header_files = 'YFNetworking/Core/*.h'
  end
  
  s.dependency 'AFNetworking', '4.0.1'
    
end
