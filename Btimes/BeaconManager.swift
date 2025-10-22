//
//  BeaconManager.swift
//  Btimes
//
//  Created by andy on 2025/10/23.
//


import Foundation
import CoreLocation
import UserNotifications
import Combine
import MessageUI

class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var beaconRegion: CLBeaconRegion?

    @Published var timestamps: [String] = [] {
        didSet {
            UserDefaults.standard.set(timestamps, forKey: "BeaconTimestamps")
        }
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadTimestamps()
        setupBeaconRegion()
    }

    func setupBeaconRegion() {
        let uuid = UUID(uuidString: "8DE9BE11-2268-4015-B040-418924420612")!
        beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "MyBeaconRegion")
        beaconRegion?.notifyOnEntry = true
        beaconRegion?.notifyOnExit = true

        if let region = beaconRegion {
            locationManager.startMonitoring(for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let timestamp = formattedTime()
        let entry = "📥 進入區域：\(timestamp)"
        addTimestamp(entry)
        sendNotification(title: "進入 iBeacon 區域", body: "時間：\(timestamp)")
        maybeSendEmail(for: timestamp)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let timestamp = formattedTime()
        let exit = "📤 離開區域：\(timestamp)"
        addTimestamp(exit)
        sendNotification(title: "離開 iBeacon 區域", body: "時間：\(timestamp)")
    }

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: Date())
    }

    func addTimestamp(_ entry: String) {
        timestamps.insert(entry, at: 0)
    }

    func clearTimestamps() {
        timestamps.removeAll()
        UserDefaults.standard.removeObject(forKey: "BeaconTimestamps")
    }

    func loadTimestamps() {
        if let saved = UserDefaults.standard.array(forKey: "BeaconTimestamps") as? [String] {
            timestamps = saved
        }
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func maybeSendEmail(for timestamp: String) {
        let today = String(timestamp.prefix(10))
        let todayEntries = timestamps.filter { $0.contains(today) }
        if todayEntries.count == 1 {
            print("📧 準備寄送當天第一筆紀錄：\(timestamp)")
            // 這裡可以觸發寄信邏輯，例如開啟郵件 App 或呼叫 API
        }
    }
}
