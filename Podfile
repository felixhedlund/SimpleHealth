# Uncomment this line to define a global platform for your project
platform :ios, '9.3'
# Uncomment this line if you're using Swift
use_frameworks!

target 'SimpleHealth' do
    pod 'IBAnimatable', :git => 'https://github.com/IBAnimatable/IBAnimatable.git', :branch => 'swift3'
    pod 'Sync', :git => 'https://github.com/hyperoslo/Sync.git'
end

target 'SimpleHealthTests' do

end

target 'SimpleHealthUITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
