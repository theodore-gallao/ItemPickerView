#
#  Be sure to run `pod spec lint ItemPickerView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
    spec.name          = 'ItemPickerView'
    spec.version       = '1.0'
    spec.summary       = 'Swipe horizontally to select through segmented items.'
    spec.license       = { :type => 'MIT', :file => 'LICENSE' }
    spec.homepage      = 'https://github.com/theodore-gallao/ItemPickerView'
    spec.authors       = { 'Theodore Gallao' => 'theodore.gallao@gmail.com' }
    spec.source        = { :git => 'https://github.com/theodore-gallao/ItemPickerView.git', :tag => '1.0' }
    spec.source_files  = 'ItemPickerView/*.swift'
    spec.platform      = :ios, '10.0'
    spec.swift_version = '4.2'
    spec.ios.framework = 'UIKit'
end
