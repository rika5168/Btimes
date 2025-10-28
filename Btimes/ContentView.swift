//
//  ContentView.swift
//  Btimes
//
//  Created by andy on 2025/10/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var beaconManager = BeaconManager()

    var groupedDates: [String] {
        let dates = beaconManager.timestamps.compactMap { entry in
            let components = entry.components(separatedBy: "：")
            if components.count > 1 {
                let fullTime = components[1].trimmingCharacters(in: .whitespaces)
                return String(fullTime.prefix(10)) // yyyy/MM/dd
            }
            return nil
        }
        return Array(Set(dates)).sorted(by: >)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groupedDates, id: \.self) { date in
                        NavigationLink(destination: RecordView(date: date, beaconManager: beaconManager)) {
                            Text("📅 \(date)")
                        }
                    }
                    .onDelete(perform: deleteDates)
                }

                HStack {
                    Button("🗑️ 清除所有紀錄") {
                        beaconManager.clearTimestamps()
                    }
                    .padding()

                    NavigationLink(destination: SettingsView()) {
                        Text("⚙️ 設定")
                    }
                    .padding()
                }
            }
            .navigationTitle("iBeacon 日期清單")
        }
    }

    func deleteDates(at offsets: IndexSet) {
        for index in offsets {
            let date = groupedDates[index]
            beaconManager.deleteRecords(for: date)
        }
    }
}
