#
#  Be sure to run `pod spec lint MDKControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name           = "MDKControl"
  spec.version      = "1.4.1"
  spec.summary        = "MDKControl is the independant control library for Movalys MDK"
  spec.description    = "MDKControl gives you a base of controls to use in you application.
                         The controls are designed to be used with Movalys MDK, but they are
                         fully independant and can be used in any iOS application develoment."
  spec.homepage       = "http://www.movalys.org"
  spec.license        = { :type => 'LGPLv3', :file => 'LGPLv3-LICENSE.txt' }
  spec.author         = "Sopra Steria Group"
  spec.source         = { :git => "https://github.com/MovalysMDK/mdk-ios-control.git", :tag => "1.4.1" }
  spec.source_files   = 'MDKControl/**/*.{h,m}'
  spec.ios.framework  = 'UIKit'
  spec.resources      = ["MDKControl/resources/images/**/*.png",
                         "MDKControl/resources/storyboard/**/*.storyboard",
                         "MDKControl/resources/strings/**/*.strings",
                         "MDKControl/resources/xib/**/*.xib",
                         "MDKControl/resources/config/**/*.plist",
                         "MDKControl/*.plist",
                         "MDKControl/*.pch"
                        ]
  spec.platform               = :ios
  spec.ios.deployment_target  = "8.0"
  spec.ios.dependency 'IQKeyboardManager', '3.3.2'
  spec.ios.dependency 'MBProgressHUD', '0.9'

end
