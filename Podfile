# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  
  # Design
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  
  # Network
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'Kingfisher', '~> 4.7.0'
  
  #CoreData
  pod 'RxCoreData'
  pod 'RxDataSources'
  
  #Alert
  pod 'SwiftMessages'
  
  # Activity Indicator
  pod 'MBProgressHUD'
  
  # keyboard
  pod 'IQKeyboardManagerSwift'
  
  # Recent Search dropdown
  pod 'DropDown'
end

target 'MovieApp' do
  shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
        end
    end
end
