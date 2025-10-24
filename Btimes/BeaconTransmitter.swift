//
//  BeaconTransmitter.swift
//  Btimes
//
//  Created by andy on 2025/10/25.
//


import Foundation
import CoreBluetooth
import CoreLocation
import Combine

class BeaconTransmitter: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published var isTransmitting: Bool = false
    @Published var bluetoothStateDescription: String = "🔄 檢查中..."

    private var peripheralManager: CBPeripheralManager?
    private var beaconData: [String: Any]?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    private func configureBeacon() {
        let uuid = UUID(uuidString: "8DE9BE11-2268-4015-B040-418924420612")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 1, minor: 1)
        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeaconRegion")

        if let data = region.peripheralData(withMeasuredPower: nil) as? [String: Any] {
            beaconData = data
        }
    }

    func startTransmitting() {
        configureBeacon()
        if peripheralManager?.state == .poweredOn, let data = beaconData {
            peripheralManager?.startAdvertising(data)
            isTransmitting = true
        }
    }

    func stopTransmitting() {
        peripheralManager?.stopAdvertising()
        isTransmitting = false
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            bluetoothStateDescription = "✅ Bluetooth 已開啟"
            if isTransmitting, let data = beaconData {
                peripheralManager?.startAdvertising(data)
            }
        case .poweredOff:
            bluetoothStateDescription = "⛔️ Bluetooth 已關閉"
            peripheralManager?.stopAdvertising()
            isTransmitting = false
        case .unauthorized:
            bluetoothStateDescription = "🚫 Bluetooth 未授權"
        case .unsupported:
            bluetoothStateDescription = "❌ 裝置不支援 Bluetooth"
        case .resetting:
            bluetoothStateDescription = "🔄 Bluetooth 重設中"
        case .unknown:
            bluetoothStateDescription = "❓ Bluetooth 狀態未知"
        @unknown default:
            bluetoothStateDescription = "⚠️ 未知 Bluetooth 狀態"
        }
    }
}
