//
//  CustomTabBar.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
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
                // タブバーの背景（iOSガラスモーフィズム効果 + Figma仕様）
                // Figma: rgba(217,217,217,0.5), 70px高さ, 361px幅, 40px角丸, 16px左マージン, top: 757px
                RoundedRectangle(cornerRadius: 40 * scaleX)
                    .fill(.regularMaterial)
                    .overlay(
                        // Figmaの色をオーバーレイとして追加
                        RoundedRectangle(cornerRadius: 40 * scaleX)
                            .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                    )
                    .frame(width: 361 * scaleX, height: 70 * scaleY)
                    .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                
                // タブボタンの配置（Figmaの正確な位置に基づく絶対配置）
                // 入力タブ（Figma: アイコン left: 51px, top: 773px, size: 24px, テキスト left: 63px中央, top: 800px）
                TabBarButton(
                    icon: "pencil.circle.fill",
                    label: "入力",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    iconSize: 24 * scaleX,
                    iconLeft: 51 * scaleX,
                    iconTop: 773 * scaleY,
                    textCenterX: 63 * scaleX,
                    textTop: 800 * scaleY,
                    tabBarTop: 757 * scaleY
                )
                
                // 成績表タブ（Figma: アイコン left: 109px, top: 771px, size: 31px, テキスト left: 123px中央, top: 800px）
                TabBarButton(
                    icon: "chart.bar.fill",
                    label: "成績表",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    iconSize: 31 * scaleX,
                    iconLeft: 109 * scaleX,
                    iconTop: 771 * scaleY,
                    textCenterX: 123 * scaleX,
                    textTop: 800 * scaleY,
                    tabBarTop: 757 * scaleY
                )
                
                // 履歴タブ（Figma: アイコン left: 175px, top: 773px, size: 22px, テキスト left: 186px中央, top: 800px）
                TabBarButton(
                    icon: "clock.fill",
                    label: "履歴",
                    isSelected: selectedTab == 2,
                    action: { selectedTab = 2 },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    iconSize: 22 * scaleX,
                    iconLeft: 175 * scaleX,
                    iconTop: 773 * scaleY,
                    textCenterX: 186 * scaleX,
                    textTop: 800 * scaleY,
                    tabBarTop: 757 * scaleY
                )
                
                // グループタブ（Figma: アイコン left: 236px, top: 768px, size: 32px, テキスト left: 252px中央, top: 800px）
                TabBarButton(
                    icon: "person.3.fill",
                    label: "グループ",
                    isSelected: selectedTab == 3,
                    action: { selectedTab = 3 },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    iconSize: 32 * scaleX,
                    iconLeft: 236 * scaleX,
                    iconTop: 768 * scaleY,
                    textCenterX: 252 * scaleX,
                    textTop: 800 * scaleY,
                    tabBarTop: 757 * scaleY
                )
                
                // マイページタブ（Figma: アイコン left: 311px, top: 775px, size: 22px, テキスト left: 322px中央, top: 800px）
                TabBarButton(
                    icon: "person.fill",
                    label: "マイページ",
                    isSelected: selectedTab == 4,
                    action: { selectedTab = 4 },
                    scaleX: scaleX,
                    scaleY: scaleY,
                    iconSize: 22 * scaleX,
                    iconLeft: 311 * scaleX,
                    iconTop: 775 * scaleY,
                    textCenterX: 322 * scaleX,
                    textTop: 800 * scaleY,
                    tabBarTop: 757 * scaleY
                )
            }
            .frame(width: 361 * scaleX, height: 70 * scaleY)
            .position(x: screenWidth / 2, y: screenHeight - 35 * scaleY - geometry.safeAreaInsets.bottom)
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    let scaleX: CGFloat
    let scaleY: CGFloat
    let iconSize: CGFloat
    let iconLeft: CGFloat
    let iconTop: CGFloat
    let textCenterX: CGFloat
    let textTop: CGFloat
    let tabBarTop: CGFloat
    
    // Figmaデザイン: テキストは白（text-white）
    private let textColor = Color.white
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                // アイコン（Figmaの正確な位置、タブバー内での相対位置）
                // Figma: アイコン left: 51px, top: 773px（画面全体）
                // タブバー: left: 16px, top: 757px（画面全体）
                // タブバー内での位置: left: 51 - 16 = 35px, top: 773 - 757 = 16px
                Image(systemName: icon)
                    .font(.system(size: iconSize))
                    .foregroundColor(isSelected ? textColor : textColor.opacity(0.8))
                    .frame(width: iconSize, height: iconSize)
                    .offset(
                        x: (iconLeft - 16 * scaleX) - iconSize / 2, // タブバーの左マージン16pxを引き、アイコンサイズの半分を引く
                        y: (iconTop - tabBarTop) * scaleY - iconSize / 2
                    )
                
                // ラベル（Figma: 12px, Medium, 白, 中央揃え）
                // Figma: テキスト left: 63px, top: 800px（画面全体）
                // タブバー内での位置: left: 63 - 16 = 47px, top: 800 - 757 = 43px
                Text(label)
                    .font(.system(size: 12 * scaleX, weight: .medium))
                    .foregroundColor(isSelected ? textColor : textColor.opacity(0.8))
                    .offset(
                        x: (textCenterX - 16 * scaleX), // タブバーの左マージン16pxを引く
                        y: (textTop - tabBarTop) * scaleY
                    )
            }
        }
        .frame(width: 361 * scaleX, height: 70 * scaleY)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
        .frame(height: 100)
}
