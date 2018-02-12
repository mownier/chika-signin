source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/mownier/chika-podspecs.git'
source 'https://github.com/mownier/podspecs.git'
platform :ios, '11.0'
use_frameworks!

target 'ChikaSignIn' do
    pod 'ChikaFirebase/Auth:SignIn'
    pod 'ChikaFirebase/Auth:SignOut'
    pod 'ChikaFirebase/Writer:OnlinePresenceSwitcher'
    pod 'ChikaFirebase/Writer:OfflinePresenceSwitcher'
    
    target 'ChikaSignInTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        if config.name == 'Release'
            config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
        end
    end
end

