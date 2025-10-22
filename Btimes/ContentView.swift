//
//  ContentView.swift
//  Btimes
//
//  Created by andy on 2025/10/20.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var beaconManager = BeaconManager()

    var groupedTimestamps: [String: [String]] {
        Dictionary(grouping: beaconManager.timestamps) { entry in
            // 擷取日期部分（yyyy/MM/dd）
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
            List {
                ForEach(groupedTimestamps.keys.sorted(by: >), id: \.self) { date in
                    Section(header: Text("📅 \(date)")) {
                        ForEach(groupedTimestamps[date]!, id: \.self) { entry in
                            Text(entry)
                        }
                    }
                }
            }
            .navigationTitle("iBeacon 記錄")
        }
    }
}
