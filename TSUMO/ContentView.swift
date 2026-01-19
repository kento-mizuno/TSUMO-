//
//  ContentView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.1) // デバッグ用：背景色を確認
            
            if authViewModel.isAuthenticated {
                HomeView()
                    .environmentObject(authViewModel)
            } else {
                SignInView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            print("ContentView appeared")
            authViewModel.checkAuthenticationStatus()
        }
    }
}

#Preview {
    ContentView()
}
