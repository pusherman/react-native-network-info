Pod::Spec.new do |s|
  s.name         = "react-native-network-info"
  s.version      = "5.2.1"
  s.summary      = "Get local network information"

  s.homepage     = "https://github.com/pusherman/react-native-network-info"
  s.author       = "Corey Wilson"

  s.license      = "MIT"
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/pusherman/react-native-network-info", :tag => "v#{s.version.to_s}" }

  s.source_files  = "ios/*.{h,m,c}"

  s.dependency 'React'
end
