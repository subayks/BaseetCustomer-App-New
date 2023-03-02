//
//  AppDelegate.swift
//  Baseet App
//
//  Created by VinodKatta on 07/07/22.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import UserNotifications
var fcmTokenUser:String!

@main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        Thread.sleep(forTimeInterval: 2)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {success,Error in
            guard success else{
                return
            }
            print("Apns Registred Sucessfully")
        })
        application.registerForRemoteNotifications()
        let token = Messaging.messaging().fcmToken
       
        return true
    }
    
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?){
        fcmTokenUser = fcmToken
        //UserDefaults.standard.setValue(fcmTokenUser!, forKey: "fcmToken")
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


}

