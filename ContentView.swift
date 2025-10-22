import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingProfile = false
    
    var body: some View {
        ZStack {
            // 主要內容
            VStack(spacing: 0) {
                // 頂部導航欄
                topBar
                
                // 主要內容區域
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                    
                    DevicesView()
                        .tag(1)
                    
                    AnalyticsView()
                        .tag(2)
                    
                    SettingsView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // 底部導航欄
                bottomBar
            }
            
            // 側邊個人資料頁面
            if showingProfile {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingProfile = false
                        }
                    }
                
                ProfileView()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .transition(.move(edge: .trailing))
                    .offset(x: UIScreen.main.bounds.width * 0.1)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // 頂部導航欄
    var topBar: some View {
        HStack {
            Text("Btimes")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    showingProfile.toggle()
                }
            }) {
                Image(systemName: "person.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    // 底部導航欄
    var bottomBar: some View {
        HStack {
            ForEach(0..<4) { index in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: index))
                            .font(.system(size: 24))
                        
                        Text(tabName(for: index))
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
    
    // 獲取標籤頁圖標
    func iconName(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "antenna.radiowaves.left.and.right"
        case 2: return "chart.bar.fill"
        case 3: return "gearshape.fill"
        default: return "questionmark"
        }
    }
    
    // 獲取標籤頁名稱
    func tabName(for index: Int) -> String {
        switch index {
        case 0: return "首頁"
        case 1: return "設備"
        case 2: return "分析"
        case 3: return "設置"
        default: return ""
        }
    }
}

// 首頁視圖
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 歡迎卡片
                VStack(alignment: .leading, spacing: 10) {
                    Text("歡迎回來")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("今天是 \(formattedDate())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("活躍設備")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("5")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                
                // 狀態卡片
                VStack(alignment: .leading, spacing: 15) {
                    Text("狀態概覽")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    HStack(spacing: 15) {
                        statusCard(title: "電池", value: "85%", icon: "battery.75", color: .green)
                        statusCard(title: "信號", value: "強", icon: "wifi", color: .blue)
                    }
                    
                    HStack(spacing: 15) {
                        statusCard(title: "溫度", value: "24°C", icon: "thermometer", color: .orange)
                        statusCard(title: "距離", value: "近", icon: "location.fill", color: .purple)
                    }
                }
                
                // 最近活動
                VStack(alignment: .leading, spacing: 15) {
                    Text("最近活動")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    ForEach(0..<3) { index in
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.title2)
                                .foregroundColor([.blue, .green, .orange][index])
                                .frame(width: 40, height: 40)
                                .background([.blue, .green, .orange][index].opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("設備 \(index + 1) 已連接")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("\(3 - index) 小時前")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    // 狀態卡片
    func statusCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    // 格式化日期
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
}

// 設備視圖
struct DevicesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("我的設備")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ForEach(0..<5) { index in
                    deviceCard(
                        name: "Beacon \(index + 1)",
                        id: "ID: BT\(1000 + index)",
                        status: index % 3 == 0 ? "離線" : "在線",
                        battery: "\(85 - index * 5)%",
                        isOnline: index % 3 != 0
                    )
                }
            }
            .padding(.vertical)
        }
    }
    
    // 設備卡片
    func deviceCard(name: String, id: String, status: String, battery: String, isOnline: Bool) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.headline)
                    
                    Text(id)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Circle()
                    .fill(isOnline ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(isOnline ? .green : .red)
            }
            
            Divider()
            
            HStack {
                deviceInfoItem(title: "電池", value: battery, icon: "battery.75")
                
                Divider()
                    .frame(height: 20)
                
                deviceInfoItem(title: "信號", value: isOnline ? "強" : "無", icon: "wifi")
                
                Divider()
                    .frame(height: 20)
                
                deviceInfoItem(title: "距離", value: isOnline ? "近" : "未知", icon: "location")
            }
            
            Button(action: {}) {
                Text("查看詳情")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    // 設備信息項
    func deviceInfoItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

// 分析視圖
struct AnalyticsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("數據分析")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // 圖表卡片
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("設備活動")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("本週")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // 模擬圖表
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<7) { index in
                            let height = [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.9][index]
                            
                            VStack {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.8))
                                    .frame(height: 150 * height)
                                    .cornerRadius(5)
                                
                                Text(["一", "二", "三", "四", "五", "六", "日"][index])
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    HStack {
                        VStack(spacing: 5) {
                            Text("35")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("連接次數")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 5) {
                            Text("12.5")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("平均時長(分鐘)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 5) {
                            Text("89%")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("可靠性")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                // 詳細數據
                VStack(alignment: .leading, spacing: 15) {
                    Text("詳細數據")
                        .font(.headline)
                    
                    ForEach(0..<3) { index in
                        HStack {
                            Circle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: 10, height: 10)
                            
                            Text("設備 \(index + 1)")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(85 - index * 10)%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {}) {
                        Text("查看完整報告")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// 設置視圖
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoConnectEnabled = true
    @State private var selectedLanguage = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("設置")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // 通用設置
                settingsSection(title: "通用設置") {
                    Toggle("通知", isOn: $notificationsEnabled)
                    Toggle("深色模式", isOn: $darkModeEnabled)
                    Toggle("自動連接", isOn: $autoConnectEnabled)
                    
                    Picker("語言", selection: $selectedLanguage) {
                        Text("繁體中文").tag(0)
                        Text("English").tag(1)
                        Text("日本語").tag(2)
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // 設備設置
                settingsSection(title: "設備設置") {
                    navigationLink(title: "設備管理", icon: "antenna.radiowaves.left.and.right")
                    navigationLink(title: "掃描設置", icon: "qrcode")
                    navigationLink(title: "連接歷史", icon: "clock")
                }
                
                // 賬戶設置
                settingsSection(title: "賬戶設置") {
                    navigationLink(title: "個人資料", icon: "person")
                    navigationLink(title: "安全設置", icon: "lock")
                    navigationLink(title: "隱私設置", icon: "hand.raised")
                }
            }
            .padding(.vertical)
        }
    }
    
    // 設置部分
    func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
    
    // 導航鏈接
    func navigationLink(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 25)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

// 個人資料視圖
struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 頭像和名稱
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("用戶名")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("user@example.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)
            
            Divider()
            
            // 個人資料選項
            VStack(spacing: 0) {
                profileOption(icon: "person", title: "編輯個人資料")
                profileOption(icon: "bell", title: "通知設置")
                profileOption(icon: "lock", title: "隱私與安全")
                profileOption(icon: "questionmark.circle", title: "幫助與支持")
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            Spacer()
            
            // 登出按鈕
            Button(action: {}) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("登出")
                }
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    // 個人資料選項
    func profileOption(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 25)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}