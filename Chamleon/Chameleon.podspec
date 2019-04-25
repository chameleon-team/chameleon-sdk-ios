#
# Be sure to run `pod lib lint Chameleon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'Chameleon'
    s.version          = '0.1.0'
    s.summary          = 'A short description of Chameleon.'
    s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
    s.homepage         = 'https://github.com/chameleon-team/chameleon-sdk-ios'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Sun Li' => 'sunli@didichuxing.com' }
    s.source           = { :git => 'https://github.com/chameleon-team/chameleon-sdk-ios.git', :tag => s.version.to_s }

    s.ios.deployment_target = '9.0'

    s.source_files = 'sdk_src/Classes/**/*'
    s.resource_bundles = {
      'Chameleon' => ['sdk_src/Assets/*.png']
    }
    
    s.public_header_files = 'Pod/Classes/**/*.h'
    s.dependency 'JSONModel'
    s.dependency 'Masonry', '> 0.6.3'
    s.dependency 'SDWebImage', '3.7.6'
    s.dependency 'SocketRocket'
    s.dependency 'React'
    s.dependency 'yoga'
    s.dependency 'DoubleConversion'
    s.dependency 'glog'
    s.dependency 'Folly'
end
