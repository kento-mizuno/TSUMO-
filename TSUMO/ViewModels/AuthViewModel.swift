//
//  AuthViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import AuthenticationServices

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        // モックモードの場合は自動ログイン
        if AppConfig.shared.isMockMode {
            print("🔧 Mock mode: Auto-login with mock user")
            Task {
                await signInWithMockUser()
            }
            return
        }
        
        // Firebase認証が利用可能な場合のみチェック
        guard FirebaseApp.app() != nil,
              let firebaseUser = Auth.auth().currentUser else {
            return
        }
        
        Task {
            await loadUser(userId: firebaseUser.uid)
        }
    }
    
    // モックユーザーでログイン
    private func signInWithMockUser() async {
        isLoading = true
        let mockUser = User(
            id: "mock-user-001",
            name: "モックユーザー",
            email: "mock@example.com"
        )
        currentUser = mockUser
        isAuthenticated = true
        isLoading = false
        print("✅ Mock user signed in: \(mockUser.name)")
    }
    
    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        
        // Apple Sign InはSignInWithAppleButtonで処理されるため、
        // このメソッドは実際には使用されません
        // SignInViewで直接処理します
    }
    
    func signInWithEmail(email: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://tsumo.app")
            actionCodeSettings.handleCodeInApp = true
            
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            // メール送信成功のメッセージを表示
            errorMessage = nil
        } catch {
            errorMessage = "メール送信に失敗しました: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = "サインアウトに失敗しました: \(error.localizedDescription)"
        }
    }
    
    private func loadUser(userId: String) async {
        do {
            let dataService = DataServiceManager.shared.dataService
            if let user = try await dataService.getUser(userId: userId) {
                currentUser = user
            } else {
                // 新規ユーザーの場合、作成
                let newUser: User
                if AppConfig.shared.isMockMode {
                    newUser = User(
                        id: userId,
                        name: "モックユーザー",
                        email: "mock@example.com"
                    )
                } else {
                    let firebaseUser = Auth.auth().currentUser!
                    newUser = User(
                        id: firebaseUser.uid,
                        name: firebaseUser.displayName ?? "ユーザー",
                        email: firebaseUser.email
                    )
                }
                try await dataService.createUser(user: newUser)
                currentUser = newUser
            }
            isAuthenticated = true
        } catch {
            errorMessage = "ユーザー情報の取得に失敗しました: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>, rawNonce: String?) async {
        isLoading = true
        errorMessage = nil
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    errorMessage = "トークンの取得に失敗しました"
                    isLoading = false
                    return
                }
                
                do {
                    // Firebase 12.8.0の正しいAPI: OAuthProvider.appleCredentialを使用
                    // idToken + rawNonceでFirebase credentialを作成
                    let credential = OAuthProvider.appleCredential(
                        withIDToken: idTokenString,
                        rawNonce: rawNonce,
                        fullName: appleIDCredential.fullName
                    )
                    let authResult = try await Auth.auth().signIn(with: credential)
                    await loadUser(userId: authResult.user.uid)
                } catch {
                    errorMessage = "サインインに失敗しました: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        case .failure(let error):
            errorMessage = "サインインに失敗しました: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
