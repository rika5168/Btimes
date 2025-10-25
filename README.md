# iBeaconSwiftUIApp

一款使用 SwiftUI 開發的 iBeacon 廣播與紀錄工具，支援時間戳記、分日期顯示、匯出分享與 Bluetooth 狀態提示。適合展示 iBeacon 功能或作為開源範本使用。

## 🚀 功能特色

- ✅ iBeacon 廣播控制（使用 CoreBluetooth）
- ✅ Bluetooth 狀態提示與導向 iOS 設定
- ✅ 自動記錄進出時間戳記
- ✅ 日期分組顯示紀錄
- ✅ 單日紀錄瀏覽與刪除
- ✅ 一鍵清除所有紀錄
- ✅ 匯出並透過分享面板分享紀錄

## 📱 畫面預覽

> 建議放上 2～3 張 App 截圖，例如：
>![photo_2025-10-25 18 48 48](https://github.com/user-attachments/assets/fe14e423-e5ad-45b9-9f07-6c1d65a11bec)
> - 主畫面：日期清單與匯出按鈕
> - 記錄頁：單日時間戳記列表
> - 設定頁：Beacon 開關與 Bluetooth 狀態提示

## 🛠 安裝與使用

1. 使用 Xcode 15+ 開啟專案
2. 在真實裝置上執行（模擬器不支援 iBeacon 廣播）
3. 確保 Info.plist 包含以下權限設定：

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>需要使用您的位置來偵測 iBeacon</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要使用您的位置來偵測 iBeacon</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>需要使用藍牙來發射 iBeacon 訊號</string>
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
