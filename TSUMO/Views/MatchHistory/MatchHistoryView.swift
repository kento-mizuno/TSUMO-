//
//  MatchHistoryView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct MatchHistoryView: View {
    @StateObject private var viewModel = MatchHistoryViewModel()
    
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
                    VStack(spacing: 0) {
                        // タイトル（Figma: top: 72px, left: 197.5px中央, 20px, Bold）
                        Text("履歴")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // 履歴リスト
                        VStack(spacing: 16 * scaleY) {
                            ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                                NavigationLink(destination: GameDetailView(game: game)) {
                                    MatchHistoryRowView(
                                        game: game,
                                        scaleX: scaleX,
                                        scaleY: scaleY,
                                        top: 172 + CGFloat(index) * 76 // 60px高さ + 16px間隔
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20 * scaleX)
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                    }
                }
            }
        }
        .navigationTitle("履歴")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadGames()
            }
        }
    }
}

struct MatchHistoryRowView: View {
    let game: Game
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 172 * 1.0 // 行のtop位置
    
    // Figmaデザインのカラー定義
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 172px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // ゲームタイプ（Figma: top: 182px, left: 35px, 16px, Medium）
            Text(game.gameType.rawValue)
                .font(.system(size: 16 * scaleX, weight: .medium))
                .foregroundColor(mediumBlue)
                .padding(.horizontal, 8 * scaleX)
                .padding(.vertical, 4 * scaleY)
                .background(mediumBlue.opacity(0.2))
                .cornerRadius(4 * scaleX)
                .position(x: 35 * scaleX, y: (top + 10) * scaleY) // 182 - 172 = 10
            
            // 日付（Figma: top: 202px, left: 35px, 12px, Medium, rgba(34,34,34,0.5)）
            Text(DateFormatter.gameDateFormatter.string(from: game.date))
                .font(.system(size: 12 * scaleX, weight: .medium))
                .foregroundColor(darkGray.opacity(0.5))
                .position(x: 35 * scaleX, y: (top + 30) * scaleY) // 202 - 172 = 30
            
            // スコア（Figma: top: 182px, left: 343px右揃え, 20px, Medium）
            if let playerScore = game.players.first {
                Text(formatAmount(playerScore.totalAmount))
                    .font(.system(size: 20 * scaleX, weight: .medium))
                    .foregroundColor(playerScore.totalAmount >= 0 ? mediumBlue : primaryOrange)
                    .frame(width: 71 * scaleX, alignment: .trailing)
                    .position(
                        x: (343 + 71 / 2) * scaleX,
                        y: (top + 10) * scaleY
                    )
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

#Preview {
    NavigationView {
        MatchHistoryView()
    }
}
