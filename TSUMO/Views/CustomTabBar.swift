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
                
                // タブボタンの配置（Figmaの正確な位置に基づく）
                HStack(spacing: 0) {
                    // 入力タブ（Figma: left: 63px中央, アイコン: left: 51px, size: 24px）
                    TabBarButton(
                        icon: "pencil.circle.fill",
                        label: "入力",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 },
                        scaleX: scaleX,
                        scaleY: scaleY,
                        iconSize: 24 * scaleX
                    )
                    .frame(width: 72 * scaleX) // 63px中央から次の123px中央まで = 60px, 調整で72px
                    
                    // 成績表タブ（Figma: left: 123px中央, アイコン: left: 109px, size: 31px）
                    TabBarButton(
                        icon: "chart.bar.fill",
                        label: "成績表",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 },
                        scaleX: scaleX,
                        scaleY: scaleY,
                        iconSize: 31 * scaleX
                    )
                    .frame(width: 63 * scaleX) // 123pxから186pxまで = 63px
                    
                    // 履歴タブ（Figma: left: 186px中央, アイコン: left: 175px, size: 22px）
                    TabBarButton(
                        icon: "clock.fill",
                        label: "履歴",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 },
                        scaleX: scaleX,
                        scaleY: scaleY,
                        iconSize: 22 * scaleX
                    )
                    .frame(width: 66 * scaleX) // 186pxから252pxまで = 66px
                    
                    // グループタブ（Figma: left: 252px中央, アイコン: left: 236px, size: 32px）
                    TabBarButton(
                        icon: "person.3.fill",
                        label: "グループ",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 },
                        scaleX: scaleX,
                        scaleY: scaleY,
                        iconSize: 32 * scaleX
                    )
                    .frame(width: 70 * scaleX) // 252pxから322pxまで = 70px
                    
                    // マイページタブ（Figma: left: 322px中央, アイコン: left: 311px, size: 22px）
                    TabBarButton(
                        icon: "person.fill",
                        label: "マイページ",
                        isSelected: selectedTab == 4,
                        action: { selectedTab = 4 },
                        scaleX: scaleX,
                        scaleY: scaleY,
                        iconSize: 22 * scaleX
                    )
                    .frame(width: 39 * scaleX) // 322pxから361pxまで = 39px
                }
                .frame(width: 361 * scaleX)
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
    
    // Figmaデザイン: テキストは白（text-white）
    private let textColor = Color.white
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4 * scaleY) {
                // アイコン（Figma: 22-32px, 白）
                Image(systemName: icon)
                    .font(.system(size: iconSize))
                    .foregroundColor(isSelected ? textColor : textColor.opacity(0.8))
                    .frame(height: iconSize)
                
                // ラベル（Figma: 12px, Medium, 白）
                Text(label)
                    .font(.system(size: 12 * scaleX, weight: .medium))
                    .foregroundColor(isSelected ? textColor : textColor.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
        .frame(height: 100)
}
