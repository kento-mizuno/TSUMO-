//
//  GameDetailView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
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
                // 背景色（Figma: #eb5844）
                primaryOrange
                    .ignoresSafeArea()
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        // タイトル（Figma: top: 72px, left: 197.5px中央, 20px, Bold）
                        Text("対戦詳細")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // ゲーム情報（Figma: top: 172px, left: 20px）
                        VStack(alignment: .leading, spacing: 8 * scaleY) {
                            Text("日付")
                                .font(.system(size: 12 * scaleX))
                                .foregroundColor(darkGray.opacity(0.7))
                            Text(DateFormatter.gameDateFormatter.string(from: game.date))
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(darkGray)
                        }
                        .padding(.leading, 20 * scaleX)
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        
                        // プレイヤースコア（Figma: top: 242px, left: 20px）
                        VStack(alignment: .leading, spacing: 16 * scaleY) {
                            Text("結果")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(darkGray)
                                .padding(.leading, 20 * scaleX)
                                .padding(.top, 70 * scaleY) // 242 - 172 = 70
                            
                            ForEach(Array(game.players.sorted(by: { $0.rank < $1.rank }).enumerated()), id: \.element.id) { index, player in
                                PlayerScoreRow(
                                    player: player,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 282 + CGFloat(index) * 76 // 60px高さ + 16px間隔
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("対戦詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let sign = amount >= 0 ? "+" : ""
        return sign + (formatter.string(from: NSNumber(value: amount)) ?? "0")
    }
}

struct PlayerScoreRow: View {
    let player: PlayerScore
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 282 * 1.0
    
    // Figmaデザインのカラー定義
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 282px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // 順位（Figma: top: 302px, left: 35px, 18px, Medium）
            Text("\(player.rank)位")
                .font(.system(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 35 * scaleX, y: (top + 20) * scaleY) // 302 - 282 = 20
            
            // ユーザーID（Figma: top: 302px, left: 100px, 16px, Medium）
            Text("ユーザーID: \(player.id)")
                .font(.system(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray.opacity(0.7))
                .position(x: 100 * scaleX, y: (top + 20) * scaleY)
            
            // スコア（Figma: top: 302px, left: 343px右揃え, 20px, Medium）
            Text(formatAmount(player.totalAmount))
                .font(.system(size: 20 * scaleX, weight: .medium))
                .foregroundColor(player.totalAmount >= 0 ? mediumBlue : primaryOrange)
                .frame(width: 71 * scaleX, alignment: .trailing)
                .position(
                    x: (343 + 71 / 2) * scaleX,
                    y: (top + 20) * scaleY
                )
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
        GameDetailView(game: Game(
            id: "test",
            gameType: .fourPlayer,
            players: [],
            rate: "1-2-3",
            rules: GameRules()
        ))
    }
}
