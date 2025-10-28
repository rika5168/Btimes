//
//  RecordView.swift
//  Btimes
//
//  Created by andy on 2025/10/25.
//


import SwiftUI

struct RecordView: View {
    let date: String
    @ObservedObject var beaconManager: BeaconManager
    @State private var showShareSheet = false

    var filteredRecords: [String] {
        beaconManager.timestamps.filter { $0.contains(date) }
    }

    var body: some View {
        VStack {
            List {
                ForEach(filteredRecords, id: \.self) { record in
                    Text(record)
                }
                .onDelete(perform: deleteRecord)
            }

            Button("📤 匯出並分享") {
                showShareSheet = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("📅 \(date)")
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [formatExportText()])
        }
    }

    func deleteRecord(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { filteredRecords[$0] }
        beaconManager.timestamps.removeAll { recordsToDelete.contains($0) }
    }

    func formatExportText() -> String {
        var output = "📅 日期：\(date)\n"
        for record in filteredRecords {
            output += "🕒 \(record)\n"
        }
        return output
    }
}
