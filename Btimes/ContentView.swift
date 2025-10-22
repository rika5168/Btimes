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

    var groupedTimestamps: [String: [String]] {
        Dictionary(grouping: beaconManager.timestamps) { entry in
            let components = entry.components(separatedBy: "：")
            if components.count > 1 {
                let fullTime = components[1].trimmingCharacters(in: .whitespaces)
                return String(fullTime.prefix(10)) // yyyy/MM/dd
            }
            return "未知日期"
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groupedTimestamps.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text("📅 \(date)")) {
                            ForEach(groupedTimestamps[date]!, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                }

                HStack {
                    Button("🗑️ 清除紀錄") {
                        beaconManager.clearTimestamps()
                    }
                    .padding()

                    Button("📤 匯出紀錄") {
                        exportText = beaconManager.timestamps.joined(separator: "\n")
                        showShareSheet = true
                    }
                    .padding()
                }
            }
            .navigationTitle("iBeacon 記錄")
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [exportText])
            }
        }
    }
}
