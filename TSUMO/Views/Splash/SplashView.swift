//
//  SplashView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct SplashView: View {
    @State private var progress: Double = 0.1 // 10%からスタート
    @State private var isComplete = false
    @StateObject private var authViewModel = AuthViewModel()
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let lightPink = Color(red: 0.98, green: 0.95, blue: 0.95) // オフホワイト
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
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
                        y: (150 + 551 / 2) * scaleY // top: 150px + height/2
                    )
                
                // ロゴ（TSUMO_logo画像）- Figma: Group 27 (left: 104px, top: 276px)
                Image("TSUMO_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 203 * scaleX, height: 72.5 * scaleY)
                    .position(
                        x: (104 + 203 / 2) * scaleX, // left + width/2
                        y: (276 + 72.5 / 2) * scaleY  // top + height/2
                    )
                
                // プログレスバー背景 - Figma: Rectangle 3 (left: 56px, top: 415px, width: 280px, height: 42px)
                RoundedRectangle(cornerRadius: 40 * scaleX)
                    .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                    .frame(width: 280 * scaleX, height: 42 * scaleY)
                    .position(
                        x: (56 + 280 / 2) * scaleX, // left + width/2
                        y: (415 + 42 / 2) * scaleY  // top + height/2
                    )
                    .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                
                // プログレスバーの進捗 - Figma: Rectangle 2 (left: 56px, top: 417px, width: 60px (10%), height: 41px, bg-[#222])
                let progressBarLeft: CGFloat = 56
                let progressBarWidth: CGFloat = 280
                let progressBarTop: CGFloat = 417
                let progressBarHeight: CGFloat = 41
                let currentProgressWidth = max(0, CGFloat(progress) * progressBarWidth)
                
                RoundedRectangle(cornerRadius: 20 * scaleX)
                    .fill(darkGray) // Figma: #222
                    .frame(width: currentProgressWidth * scaleX, height: progressBarHeight * scaleY)
                    .position(
                        x: (progressBarLeft + currentProgressWidth / 2) * scaleX, // left + progress width/2
                        y: (progressBarTop + progressBarHeight / 2) * scaleY  // top + height/2
                    )
                
                // パーセンテージ表示 - Figma: left: 65px, top: 428px, text-[24px]
                // 10%の時は固定位置（left: 65px）、それ以降は進捗バーの右端に移動
                if progress > 0 {
                    // テキストがはみ出さないようにするオフセット
                    let textOffset: CGFloat = 35
                    
                    // 10%台: Figmaの固定位置、20%以降: 進捗バーの右端に移動
                    let percentageX: CGFloat = progress < 0.2 
                        ? 65 
                        : progressBarLeft + currentProgressWidth - textOffset
                    
                    let percentageY: CGFloat = progress < 0.2 
                        ? 428 
                        : progressBarTop + progressBarHeight / 2
                    
                    Text("\(Int(progress * 100))%")
                        .font(.custom("LuckiestGuy-Regular", size: 24 * scaleX)) // Figma: text-[24px]
                        .foregroundColor(.white)
                        .position(
                            x: percentageX * scaleX,
                            y: percentageY * scaleY
                        )
                }
                
                // キャラクターアイコン（進捗に応じて増える）
                // Figmaデザインから正確な位置を取得
                // 10%台: TSUMO_1 (left: 58px)
                // 20%台: TSUMO_1 (58px) + TSUMO_2 (94.34px)
                // 30%台: TSUMO_1-3 (58px, 94.34px, 116.16px)
                // 40%台: TSUMO_1-4 (58px, 94.34px, 116.16px, 157.04px)
                // 50%台: TSUMO_1-5 (58px, 94.34px, 116.16px, 157.04px, 193.69px)
                // 60%台: TSUMO_1-6 (58px, 94.34px, 116.16px, 157.04px, 193.69px, 229.94px)
                // 70%台: TSUMO_1-7 (58px, 94.34px, 116.16px, 157.04px, 193.69px, 229.94px, 256.21px)
                // 80%台: TSUMO_1-8 (58px, 94.34px, 116.16px, 157.04px, 193.69px, 229.94px, 256.21px, 282.82px)
                // 90%台: TSUMO_1-9 (58px, 94.34px, 116.16px, 157.04px, 193.69px, 229.94px, 256.21px, 282.82px, 304.79px)
                
                // キャラクターの位置とサイズの定義（Figmaから取得）
                let characterPositions: [(left: CGFloat, width: CGFloat, imageName: String)] = [
                    (58, 31.343, "TSUMO_1"),
                    (94.34, 16.813, "TSUMO_2"),
                    (116.16, 35.882, "TSUMO_3"),
                    (157.04, 31.648, "TSUMO_4"),
                    (193.69, 31.25, "TSUMO_5"),
                    (229.94, 21.269, "TSUMO_6"),
                    (256.21, 21.615, "TSUMO_7"),
                    (282.82, 16.964, "TSUMO_8"),
                    (304.79, 31.343, "TSUMO_9")
                ]
                
                // 進捗に応じて表示するキャラクター数を決定
                let characterCount: Int = {
                    if progress < 0.2 {
                        return 1 // 10%台
                    } else if progress < 0.3 {
                        return 2 // 20%台
                    } else if progress < 0.4 {
                        return 3 // 30%台
                    } else if progress < 0.5 {
                        return 4 // 40%台
                    } else if progress < 0.6 {
                        return 5 // 50%台
                    } else if progress < 0.7 {
                        return 6 // 60%台
                    } else if progress < 0.8 {
                        return 7 // 70%台
                    } else if progress < 0.9 {
                        return 8 // 80%台
                    } else {
                        return 9 // 90%台
                    }
                }()
                
                // キャラクターを表示
                ForEach(0..<min(characterCount, characterPositions.count), id: \.self) { index in
                    let pos = characterPositions[index]
                    Image(pos.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: pos.width * scaleX, height: 30 * scaleY)
                        .position(
                            x: (pos.left + pos.width / 2) * scaleX,
                            y: (483 + 30 / 2) * scaleY
                        )
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            print("SplashView appeared")
            startLoading()
        }
        .fullScreenCover(isPresented: $isComplete) {
            SignInView()
                .environmentObject(authViewModel)
                .onAppear {
                    print("SplashView: Opening SignInView")
                }
        }
    }
    
    private func startLoading() {
        // アニメーションでプログレスを更新
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.linear(duration: 0.1)) {
                progress += 0.02
                
                if progress >= 1.0 {
                    timer.invalidate()
                    // 認証状態を確認
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isComplete = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
