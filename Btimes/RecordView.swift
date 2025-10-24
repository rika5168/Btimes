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

    var filteredRecords: [String] {
        beaconManager.timestamps.filter { $0.contains(date) }
    }

    var body: some View {
        List {
            ForEach(filteredRecords, id: \.self) { record in
                Text(record)
            }
            .onDelete(perform: deleteRecord)
        }
        .navigationTitle("📅 \(date)")
    }

    func deleteRecord(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { filteredRecords[$0] }
        beaconManager.timestamps.removeAll { recordsToDelete.contains($0) }
    }
}
