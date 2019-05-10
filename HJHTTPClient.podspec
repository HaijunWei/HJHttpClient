Pod::Spec.new do |s|
  s.name         = "HJHTTPClient"
  s.version      = "1.0.0"
  s.summary      = "网络请求框架"
  s.homepage     = "https://github.com/HaijunWei/HJHTTPClient.git"
  s.license      = "MIT"
  s.author       = { "Haijun" => "whj929159021@hotmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/HaijunWei/HJHTTPClient.git", :tag => s.version.to_s }
  s.requires_arc = true
  
  s.default_subspec = "Full"

  s.subspec 'Full' do |ss|
    ss.dependency "HJHTTPClient/Core"
    ss.dependency "HJHTTPClient/Decoder"
    ss.dependency "HJHTTPClient/Indicator"
  end

  s.subspec 'Core' do |ss|
    ss.source_files  = "Classes/Core/*.{h,m}"
    ss.dependency "AFNetworking"
  end

  s.subspec 'Decoder' do |ss|
    ss.source_files  = "Classes/Decoder/*.{h,m}"
    ss.dependency "MJExtension"
    ss.dependency "HJHTTPClient/Core"
  end

  s.subspec 'Indicator' do |ss|
    ss.source_files  = "Classes/Indicator/*.{h,m}"
    ss.dependency "MBProgressHUD"
    ss.dependency "HJHTTPClient/Core"
  end

end
