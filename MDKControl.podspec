#
#  Be sure to run `pod spec lint MDKControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MDKControl"
  s.version      = "0.0.1"
  s.summary      = "MDKControl is the independant control library for Movalys MDK"
  s.description  = "MDKControl gives you a base of controls to use in you application.
                    The controls are designed to be used with Movalys MDK, but they are
                    fully independant and can be used in any iOS application develoment."
  s.homepage     = "http://www.soprasteria.com/"
  s.license      = "MIT (example)"
  s.author       = "Sopra Steria"
  s.source       = { :git => "gitmovalys@git.ptx.fr.sopra:mdkcontrol", :tag => "0.0.1" }
  s.source_files = 'MDKControl/**/*.{h,m}'

end
