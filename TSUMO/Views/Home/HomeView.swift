//
//  HomeView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    
    var body: some View {
        if authViewModel.isAuthenticated {
            ZStack {
                // 背景色
                primaryOrange
                    .ignoresSafeArea()
                
                // メインコンテンツ
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 70) // タブバーの高さ分のパディング
                
                // カスタムタブバー
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        } else {
            SignInView()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case 0:
            GameTypeSelectionViewWrapper()
        case 1:
            NavigationView {
                StatisticsView()
            }
        case 2:
            MatchHistoryView()
        case 3:
            GroupsView()
        case 4:
            MyPageView()
        default:
            GroupsView()
        }
    }
}

// GameTypeSelectionViewをNavigationViewなしで使用するためのラッパー
struct GameTypeSelectionViewWrapper: View {
    var body: some View {
        GameTypeSelectionViewContent(groupId: nil)
    }
}

struct GameTypeSelectionViewContent: View {
    let groupId: String?
    @State private var selectedGameType: GameType?
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    
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
                // 背景色
                primaryOrange
                    .ignoresSafeArea()
                
                // タイトル（Figma: top: 71px, left: 190px中央, 20px, Bold）
                // translate-x: -50%で中央揃え
                Text("入力")
                    .font(.system(size: 20 * scaleX, weight: .bold))
                    .foregroundColor(.white)
                    .position(x: 190 * scaleX, y: 71 * scaleY)
                
                // 4人麻雀ボタン（Figma: top: 148px, left: 16px, width: 361px, height: 120px）
                // アイコン: left: 45px, top: 183px, width: 52.747px, height: 50px
                // テキスト: left: 143px, top: 180px, 40px, Dela_Gothic_One
                GameTypeButton(
                    gameType: .fourPlayer,
                    iconName: "TSUMO_3",
                    isSelected: selectedGameType == .fourPlayer,
                    action: { selectedGameType = .fourPlayer },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    buttonLeft: 16,
                    buttonTop: 148,
                    iconLeft: 45,
                    iconTop: 183,
                    iconWidth: 52.747,
                    textLeft: 143,
                    textTop: 180
                )
                
                // 3人麻雀ボタン（Figma: top: 292px, left: 16px, width: 361px, height: 120px）
                // アイコン: left: 46px, top: 327px, width: 59.804px, height: 50px
                // テキスト: left: 143px, top: 319px, 40px, Dela_Gothic_One
                GameTypeButton(
                    gameType: .threePlayer,
                    iconName: "TSUMO_4",
                    isSelected: selectedGameType == .threePlayer,
                    action: { selectedGameType = .threePlayer },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    buttonLeft: 16,
                    buttonTop: 292,
                    iconLeft: 46,
                    iconTop: 327,
                    iconWidth: 59.804,
                    textLeft: 143,
                    textTop: 319
                )
                
                // フリー麻雀ボタン（Figma: top: 436px, left: 16px, width: 361px, height: 120px）
                // アイコン: left: 47px, top: 471px, width: 52.083px, height: 50px
                // テキスト: left: 122px, top: 468px, 40px, Dela_Gothic_One
                GameTypeButton(
                    gameType: .free,
                    iconName: "TSUMO_5",
                    isSelected: selectedGameType == .free,
                    action: { selectedGameType = .free },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    buttonLeft: 16,
                    buttonTop: 436,
                    iconLeft: 47,
                    iconTop: 471,
                    iconWidth: 52.083,
                    textLeft: 122,
                    textTop: 468
                )
            }
        }
    }
}

// Dela Gothic Oneフォントのヘルパー関数
func customDelaGothicFont(size: CGFloat) -> Font {
    // 複数のフォント名を試す（一般的な順序）
    let fontNames = [
        "Dela Gothic One",      // ファミリー名（最も一般的）
        "DelaGothicOne-Regular", // PostScript名
        "DelaGothicOne",         // 短縮形
        "Dela_Gothic_One"        // アンダースコア版
    ]
    
    for fontName in fontNames {
        if let font = UIFont(name: fontName, size: size) {
            return Font(font)
        }
    }
    
    // フォントが見つからない場合はシステムフォントを使用
    return .system(size: size, weight: .bold)
}

struct GameTypeButton: View {
    let gameType: GameType
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    let scaleX: CGFloat
    let scaleY: CGFloat
    let buttonLeft: CGFloat // ボタンの左位置（画面全体からの位置）
    let buttonTop: CGFloat // ボタンの上位置（画面全体からの位置）
    let iconLeft: CGFloat // アイコンの左位置（画面全体からの位置）
    let iconTop: CGFloat // アイコンの上位置（画面全体からの位置）
    let iconWidth: CGFloat // アイコンの幅
    let textLeft: CGFloat // テキストの左位置（画面全体からの位置）
    let textTop: CGFloat // テキストの上位置（画面全体からの位置）
    
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                // 背景（Figma: width: 361px, height: 120px）
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 361 * scaleX, height: 120 * scaleY)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? mediumBlue : Color.clear, lineWidth: 3)
                    )
                
                // アイコン（Figma: 50px高さ, 各ボタンで異なる幅）
                // ボタン内での相対位置: (iconLeft - buttonLeft, iconTop - buttonTop)
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconWidth * scaleX, height: 50 * scaleY)
                    .offset(
                        x: (iconLeft - buttonLeft) * scaleX,
                        y: (iconTop - buttonTop) * scaleY
                    )
                
                // テキスト（Figma: 40px, Dela Gothic One, #4591d3）
                // ボタン内での相対位置: (textLeft - buttonLeft, textTop - buttonTop)
                Text(gameType.rawValue)
                    .font(customDelaGothicFont(size: 40 * scaleX))
                    .foregroundColor(mediumBlue)
                    .offset(
                        x: (textLeft - buttonLeft) * scaleX,
                        y: (textTop - buttonTop) * scaleY
                    )
            }
        }
        .position(
            x: (buttonLeft + 180.5) * scaleX, // ボタンの中心位置（left + width/2）
            y: (buttonTop + 60) * scaleY // ボタンの中心位置（top + height/2）
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
