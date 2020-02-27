#
# Be sure to run `pod lib lint GYHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GYHUD'
  s.version          = '0.1.1'
  s.summary          = 'An iOS activity indicator view based on MBProgressHUD..'
  s.description      = <<-DESC
                      GYHUD is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread.
                      The HUD is meant as a replacement for MBProgressHUD with some additional features.
                       DESC

  s.homepage         = 'https://github.com/GithubGaoYang/GYHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '高扬' => 'gaoyangzhongguo@foxmail.com' }
  s.source           = { :git => 'https://github.com/GithubGaoYang/GYHUD.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version    = '5.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'GYHUD/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GYHUD' => ['GYHUD/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MBProgressHUD',  '~> 1.2.0'
  s.dependency 'NVActivityIndicatorView'

end
