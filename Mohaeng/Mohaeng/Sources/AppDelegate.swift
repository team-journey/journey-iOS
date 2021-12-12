//
//  AppDelegate.swift
//  Journey
//
//  Created by 초이 on 2021/06/28.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift
import FontBlaster
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // firebase 연동
        FirebaseApp.configure()
        
        // push notification 권한 요청하기
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: authOptions,completionHandler: { (_, _) in }
            )
        application.registerForRemoteNotifications()
        
        // 키보드 내려가는 현상 방지
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // custom font load
        FontBlaster.blast()
        
        // 카카오 로그인
        KakaoSDKCommon.initSDK(appKey: "76520e61eaf787345929bd73ec5ca3df")
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           
           // 세로방향 고정
           return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmTokenString = fcmToken else {
            return
        }
        print("Firebase registration token: \(fcmTokenString)")
        UserDefaults.standard.set(fcmTokenString, forKey: "fcmToken")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
}



extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
