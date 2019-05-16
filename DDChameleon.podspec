#
# Be sure to run `pod lib lint Chameleon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'DDChameleon'
    s.version          = '1.0.0'
    s.ios.deployment_target = '9.0'
    
    s.summary          = '🦎 一套代码运行多端，一端所见即多端所见'
    s.description      = <<-DESC
            主站:https://cml.js.org/
                       DESC
    s.homepage         = 'https://github.com/didi/chameleon'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Chameleon Team' => 'ChameleonCore@didiglobal.com' }
    s.source           = { :git => 'https://github.com/chameleon-team/chameleon-sdk-ios.git', :tag => s.version.to_s }

    s.source_files = 'sdk_src/**/*'
    s.public_header_files = 'Pod/Classes/**/*.h'

    s.dependency 'JSONModel'
    s.dependency 'Masonry'
    s.dependency 'WeexSDK', '~> 0.19.0.2'
    s.dependency 'SocketRocket'
    s.dependency 'SDWebImage'
    
end
