source 'https://cdn.cocoapods.org/'
source 'https://github.com/depromeet/Tiqui-Taca_iOS_Podspec.git'

platform :ios, '15.0'
inhibit_all_warnings!

target 'TiquiTaca_iOS' do
  use_frameworks!
  
  # UI
  pod 'BottomSheetSwiftUI', '= 2.7.0'
  pod 'Map', :git => 'https://github.com/pauljohanneskraft/Map', :branch => 'hit-testing'
  pod 'ExytePopupView', '= 1.1.4'
  
  # Firebase
  pod 'Firebase/Analytics', '= 8.15.0'
  pod 'Firebase/Messaging', '= 8.15.0'

  # DB
  pod 'RealmSwift', '= 10.25.1'

  # Security
  pod 'KeychainAccess', '= 4.2.2'
  pod 'CryptoSwift', '= 1.4.3'

  # Util
  pod 'SwiftLint', '= 0.47.0'
  pod 'R.swift', '= 6.1.0'
  pod 'LicensePlist', '= 3.22.0'

  # Socket
  pod 'Socket.IO-Client-Swift', '= 16.0.0'

  # Tiqui-Taca_iOS_Podspec
  pod 'ComposableArchitecture'
  pod 'CasePaths'
  pod 'CombineSchedulers'
  pod 'CustomDump'
  pod 'IdentifiedCollections'
  pod 'XCTestDynamicOverlay'
  pod 'ComposableCoreLocation'

  target 'TiquiTaca_iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  # Generate LicensePlist
  system("rm -rf Settings.bundle/tiqui-taca.LicensePlist")
  system("rm -f Settings.bundle/tiqui-taca.LicensePlist.plist")
  system("Pods/LicensePlist/license-plist --add-version-numbers --suppress-opening-directory --output-path Settings.bundle --prefix tiqui-taca.LicensePlist")
  system("rm -f Settings.bundle/tiqui-taca.LicensePlist.latest_result.txt")
end
