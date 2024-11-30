//
//  AppDelegate.swift
//  Yara
//
//  Created by Johnny Owayed on 12/10/2024.
//

import UIKit
import FirebaseCore
import OneSignalFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Remove this method to stop OneSignal Debugging
          OneSignal.Debug.setLogLevel(.LL_VERBOSE)
          
          // OneSignal initialization
          OneSignal.initialize("21a9405b-5645-474b-bbc5-f3663a4d3342", withLaunchOptions: launchOptions)
          
          
          // Login your customer with externalId
          // OneSignal.login("EXTERNAL_ID")
        
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


}

