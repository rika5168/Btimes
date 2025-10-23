//
//  ContentView.swift
//  Btimes
//
//  Created by andy on 2025/10/23.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var beaconManager = BeaconManager()
    @State private var showShareSheet = false
    @State private var exportText = ""

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

                    Button("📤 匯出並分享") {
                        exportText = beaconManager.timestamps.joined(separator: "\n")
                        showShareSheet = true
                    }
                    .padding()
                }
            }
            .navigationTitle("iBeacon 日期清單")
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [exportText])
            }
        }
    }

    func deleteDates(at offsets: IndexSet) {
        for index in offsets {
            let date = groupedDates[index]
            beaconManager.deleteRecords(for: date)
        }
    }
}
