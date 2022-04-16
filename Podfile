source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/depromeet/Tiqui-Taca_iOS_Podspec.git'

platform :ios, '15.0'
inhibit_all_warnings!

target 'TiquiTaca_iOS' do
  use_frameworks!

  # DB
  pod 'RealmSwift', '= 10.25.1'

  # Security
  pod 'KeychainAccess', '= 4.2.2'
  pod 'CryptoSwift', '= 1.4.3'

  # Util
  pod 'SwiftLint', '= 0.47.0'
  pod 'R.swift', '= 6.1.0'

  # Tiqui-Taca_iOS_Podspec
  pod 'ComposableArchitecture'
  pod 'CasePaths'
  pod 'CombineSchedulers'
  pod 'CustomDump'
  pod 'IdentifiedCollections'
  pod 'XCTestDynamicOverlay'

  target 'TiquiTaca_iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
