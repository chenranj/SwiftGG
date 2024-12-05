//
//  SwiftGGApp.swift
//  SwiftGG
//
//  Created by Chenran Jin on 12/2/24.
//

import SwiftUI

@main
struct SwiftGGApp: App {
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
            
                .alert("网络连接已断开", isPresented: $networkMonitor.showAlert) {
                    Button("好的", role: .cancel) { }
                } message: {
                    Text("请检查网络连接后重试")
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // 禁用网络日志
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.set(false, forKey: "\(bundleIdentifier).OS_ACTIVITY_MODE")
        }
        
        // 禁用 Metal 警告
        UserDefaults.standard.set(false, forKey: "MTL_DEBUG_LAYER")
        
        return true
    }
}
