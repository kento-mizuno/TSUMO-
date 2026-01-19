//
//  SignInView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct SignInView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var showEmailSent = false
    @State private var currentNonce: String?
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let lightPink = Color(red: 0.98, green: 0.95, blue: 0.95) // オフホワイト
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            // Figmaデザインの基準サイズ: 393 x 852
            let designWidth: CGFloat = 393
            let designHeight: CGFloat = 852
            let scaleX = screenWidth / designWidth
            let scaleY = screenHeight / designHeight
            
            ZStack {
                // 背景色（赤オレンジ）
                primaryOrange
                    .ignoresSafeArea()
                
                // 中央のピンクエリア（楕円形）- Figma: Ellipse 149 (685 x 551)
                Ellipse()
                    .fill(lightPink)
                    .frame(width: 685 * scaleX, height: 551 * scaleY)
                    .position(
                        x: screenWidth / 2,
                        y: (150 + 551 / 2) * scaleY
                    )
                
                // ロゴ（TSUMO_logo画像）- Figma: Group 27 (left: 104px, top: 276px)
                Image("TSUMO_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 203 * scaleX, height: 72.5 * scaleY)
                    .position(
                        x: (104 + 203 / 2) * scaleX,
                        y: (276 + 72.5 / 2) * scaleY
                    )
                
                // Apple Sign Inボタン - Figma: Rectangle 4 (left: 61px, top: 418px, width: 280px, height: 40px)
                // iOS公式のSignInWithAppleButtonを使用
                SignInWithAppleButton(
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.nonce = sha256(nonce)
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        Task {
                            await viewModel.handleAppleSignInResult(result, rawNonce: currentNonce)
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: 280 * scaleX, height: 40 * scaleY)
                .cornerRadius(40 * scaleX)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (61 + 280 / 2) * scaleX,
                    y: (418 + 40 / 2) * scaleY
                )
                
                // "OR"テキスト - Figma: text "OR" (left: 182px, top: 476px)
                Text("OR")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.3))
                    .position(
                        x: 182 * scaleX,
                        y: 476 * scaleY
                    )
                
                // メールアドレス入力フィールド - Figma: Rectangle 5 (left: 61px, top: 515px, width: 280px, height: 42px)
                TextField("メールアドレス", text: $email)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16 * scaleX)
                    .frame(width: 280 * scaleX, height: 42 * scaleY)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                    .cornerRadius(8 * scaleX)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .position(
                        x: (61 + 280 / 2) * scaleX,
                        y: (515 + 42 / 2) * scaleY
                    )
                
                // ログインボタン - Figma: Rectangle 6 (left: 61px, top: 573px, width: 280px, height: 40px)
                Button(action: {
                    Task {
                        await viewModel.signInWithEmail(email: email)
                        if viewModel.errorMessage == nil {
                            showEmailSent = true
                        }
                    }
                }) {
                    Text("ログイン用のリンクを送信")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 280 * scaleX, height: 40 * scaleY)
                        .background(darkGray)
                        .cornerRadius(40 * scaleX)
                        .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                }
                .disabled(email.isEmpty || !isValidEmail(email))
                .position(
                    x: (61 + 280 / 2) * scaleX,
                    y: (573 + 40 / 2) * scaleY
                )
            }
        }
        .onAppear {
            // モックモードの場合は自動ログインを試みる
            if AppConfig.shared.isMockMode && !viewModel.isAuthenticated {
                viewModel.checkAuthenticationStatus()
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.isAuthenticated },
            set: { _ in }
        )) {
            ContentView()
                .environmentObject(viewModel)
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // nonceを生成する関数
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // SHA256ハッシュを生成する関数
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

#Preview {
    SignInView()
}
