//
//  AppDelegate.swift
//  Btimes
//
//  Created by andy on 2025/10/25.
//


import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("✅ 通知權限已授權")
            } else {
                print("⚠️ 通知權限被拒絕")
            }
        }

        return true
    }
}
