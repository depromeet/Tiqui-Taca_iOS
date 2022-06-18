//
//  AppDelegate.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/17.
//
//

import UIKit
import Firebase
import UserNotifications

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions
    ) { granted, error in
      if granted {
        print("알림이 정상적으로 등록 되었습니다.")
      } else if let error = error {
        print("알림 등록 실패: \(error.localizedDescription)")
      }
    }
    application.registerForRemoteNotifications()
    
    // kill 상태에서 푸시알림 선택
    if let options = launchOptions,
       let userInfo = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
      if let deeplinkString = userInfo["deepLink"] as? String {
        DeeplinkManager.shared.handleDeeplink(with: deeplinkString)
      }
    }
    
    return true
  }
  
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    completionHandler(.noData)
  }
  
  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // foreground에서 푸시알림 선택
    if let deeplinkString = userInfo["deepLink"] as? String {
      DeeplinkManager.shared.handleDeeplink(with: deeplinkString)
    }
    
    completionHandler([.sound, .banner, .list])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // background에서 푸시알림 선택
    if let deeplinkString = userInfo["deepLink"] as? String {
      DeeplinkManager.shared.handleDeeplink(with: deeplinkString)
    }
    
    completionHandler()
  }
}
