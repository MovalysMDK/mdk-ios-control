#
#  Be sure to run `pod spec lint MDKControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MDKControl"
  s.version      = "1.0.1-RC1"
  s.summary      = "MDKControl is the independant control library for Movalys MDK"
  s.description  = "MDKControl gives you a base of controls to use in you application.
                    The controls are designed to be used with Movalys MDK, but they are
                    fully independant and can be used in any iOS application develoment."
  s.homepage     = "https://www.soprasteria.com/fr"
  s.license      = { :type => 'LGPL', :text => <<-LICENSE
    Copyright (C) 2010 Sopra (support_movalys@sopra.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
    LICENSE
    }
  s.author       = "Sopra Steria"
  s.source       = { :git => "gitmovalys@git.ptx.fr.sopra:mdk-ios-control.git", :tag => "1.0.1-RC1" }
  s.source_files = 'MDKControl/**/*.{h,m}'
  s.ios.framework = 'UIKit'
  s.resources     = ["MDKControl/resources/images/**/*.png", 
                     "MDKControl/resources/storyboard/**/*.storyboard",
                     "MDKControl/resources/strings/**/*.strings",
                     "MDKControl/resources/xib/**/*.xib",
                     "MDKControl/resources/config/**/*.plist",
                     "MDKControl/*.plist",
                     "MDKControl/*.pch"
                     ]
  s.platform      = :ios
  s.ios.deployment_target = "8.0"
  s.ios.dependency 'IQKeyboardManager', '3.3.2'
  s.ios.dependency 'MBProgressHUD', '0.9'

end
