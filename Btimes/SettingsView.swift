//
//  SettingsView.swift
//  Btimes
//
//  Created by andy on 2025/10/25.
//


import SwiftUI

struct SettingsView: View {
    @StateObject private var transmitter = BeaconTransmitter()

    var body: some View {
        VStack(spacing: 30) {
            Text("設定")
                .font(.largeTitle)
                .bold()

            Toggle("啟用 iBeacon 發射器", isOn: $transmitter.isTransmitting)
                .onChange(of: transmitter.isTransmitting) { isOn in
                    isOn ? transmitter.startTransmitting() : transmitter.stopTransmitting()
                }
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .blue))

            Text(transmitter.isTransmitting ? "✅ Beacon 正在廣播中" : "⛔️ Beacon 已停止廣播")
                .foregroundColor(transmitter.isTransmitting ? .green : .red)

            Text(transmitter.bluetoothStateDescription)
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle("設定")
    }
}
