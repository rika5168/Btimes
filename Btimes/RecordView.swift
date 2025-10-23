//
//  RecordView.swift
//  Btimes
//
//  Created by andy on 2025/10/23.
//


import SwiftUI

struct RecordView: View {
    let date: String
    let allRecords: [String]

    var filteredRecords: [String] {
        allRecords.filter { $0.contains(date) }
    }

    var body: some View {
        List(filteredRecords, id: \.self) { record in
            Text(record)
        }
        .navigationTitle("📅 \(date)")
    }
}
