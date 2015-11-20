Pod::Spec.new do |s|
  s.name         = "react-native-network-info"
  s.version      = "0.1.1"
  s.summary      = "Get local network information"

  s.homepage     = "https://github.com/pusherman/react-native-network-info"

  s.license      = "MIT"
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/pusherman/react-native-network-info" }

  s.source_files  = "ios/*.{h,m}"

  s.dependency 'React'
end
