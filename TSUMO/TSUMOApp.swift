//
//  TSUMOApp.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI
import FirebaseCore

@main
struct TSUMOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        print("TSUMOApp init")
        // Firebaseの初期化（オプショナル：失敗しても続行）
        configureFirebase()
    }
    
    private func configureFirebase() {
        // GoogleService-Info.plistが存在するかチェック
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              FileManager.default.fileExists(atPath: path) else {
            print("⚠️ GoogleService-Info.plist not found. Running in mock mode.")
            AppConfig.shared.isMockMode = true
            return
        }
        
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
        AppConfig.shared.isMockMode = false
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.blue.opacity(0.1) // デバッグ用：背景色を確認
                SplashView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("AppDelegate didFinishLaunchingWithOptions")
        // Firebase初期化はTSUMOAppのinitで行うため、ここでは何もしない
        return true
    }
}

// アプリ全体で使用する設定
class AppConfig {
    static let shared = AppConfig()
    var isMockMode = false
    
    private init() {}
}
