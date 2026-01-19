//
//  MyPageView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    
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
                // 背景色（Figma: #eb5844）
                primaryOrange
                    .ignoresSafeArea()
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        // タイトル（Figma: top: 72px, left: 197.5px中央, 20px, Bold）
                        Text("マイページ")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // ユーザー情報（Figma: top: 172px, 18px, Bold, 中央揃え）
                        if let user = viewModel.currentUser {
                            VStack(spacing: 8 * scaleY) {
                                Text(user.name)
                                    .font(.system(size: 18 * scaleX, weight: .bold))
                                    .foregroundColor(darkGray)
                                if let email = user.email {
                                    Text(email)
                                        .font(.system(size: 12 * scaleX))
                                        .foregroundColor(darkGray.opacity(0.5))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        }
                        
                        // 統計情報（Figma: top: 242px, 60px高さ, 353px幅, 20px左マージン）
                        if viewModel.isLoading {
                            ProgressView()
                                .position(x: screenWidth / 2, y: 242 * scaleY)
                        } else {
                            VStack(spacing: 16 * scaleY) {
                                StatCard(
                                    title: "総ゲーム数",
                                    value: "\(viewModel.totalGames)回",
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 242
                                )
                                StatCard(
                                    title: "平均順位",
                                    value: String(format: "%.2f", viewModel.averageRank),
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 318 // 242 + 60 + 16 = 318
                                )
                                StatCard(
                                    title: "総合収支",
                                    value: formatAmount(viewModel.totalBalance),
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 394 // 318 + 60 + 16 = 394
                                )
                            }
                            .padding(.horizontal, 20 * scaleX)
                            .padding(.top, 70 * scaleY) // 242 - 172 = 70
                        }
                        
                        // メニュー（Figma: top: 470px, 60px高さ, 353px幅, 20px左マージン）
                        VStack(spacing: 16 * scaleY) {
                            NavigationLink(destination: MatchHistoryView()) {
                                MenuRow(
                                    title: "対戦履歴",
                                    icon: "clock.fill",
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 470
                                )
                            }
                            NavigationLink(destination: FreeMahjongView()) {
                                MenuRow(
                                    title: "フリー麻雀",
                                    icon: "gamecontroller.fill",
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 546 // 470 + 60 + 16 = 546
                                )
                            }
                            NavigationLink(destination: MonthlySummaryView()) {
                                MenuRow(
                                    title: "月次サマリー",
                                    icon: "calendar",
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 622 // 546 + 60 + 16 = 622
                                )
                            }
                        }
                        .padding(.horizontal, 20 * scaleX)
                        .padding(.top, 228 * scaleY) // 470 - 242 = 228
                    }
                }
            }
        }
        .navigationTitle("マイページ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let sign = amount >= 0 ? "+" : ""
        return sign + (formatter.string(from: NSNumber(value: amount)) ?? "0")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 242 * 1.0
    
    // Figmaデザインのカラー定義
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 242px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // タイトル（Figma: top: 262px, left: 35px, 16px, Medium）
            Text(title)
                .font(.system(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 35 * scaleX, y: (top + 20) * scaleY) // 262 - 242 = 20
            
            // 値（Figma: top: 262px, left: 343px右揃え, 20px, Medium）
            Text(value)
                .font(.system(size: 20 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 71 * scaleX, alignment: .trailing)
                .position(
                    x: (343 + 71 / 2) * scaleX,
                    y: (top + 20) * scaleY
                )
        }
    }
}

struct MenuRow: View {
    let title: String
    let icon: String
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 470 * 1.0
    
    // Figmaデザインのカラー定義
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 470px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // アイコン（Figma: top: 490px, left: 35px, size: 24px）
            Image(systemName: icon)
                .font(.system(size: 24 * scaleX))
                .foregroundColor(darkGray)
                .frame(width: 24 * scaleX, height: 24 * scaleY)
                .position(x: 35 * scaleX, y: (top + 30) * scaleY) // 490 - 470 = 20, 中央で30
            
            // タイトル（Figma: top: 490px, left: 75px, 18px, Medium）
            Text(title)
                .font(.system(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 75 * scaleX, y: (top + 30) * scaleY)
            
            // 矢印アイコン（Figma: top: 490px, left: 343px）
            Image(systemName: "chevron.right")
                .font(.system(size: 15.203 * scaleX))
                .foregroundColor(darkGray.opacity(0.5))
                .position(x: 343 * scaleX, y: (top + 30) * scaleY)
        }
    }
}

#Preview {
    MyPageView()
}
