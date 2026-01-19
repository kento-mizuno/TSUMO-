//
//  ScoreInputView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct ScoreInputView: View {
    let groupId: String?
    let gameType: GameType
    let rules: GameRules
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ScoreInputViewModel()
    @State private var players: [PlayerInput] = []
    @State private var chip: Int = 0
    @State private var tableFee: Int = 0
    @State private var gameFee: Int = 0
    
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
                        Text("スコア入力")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // プレイヤースコア（Figma: top: 172px, left: 20px）
                        VStack(alignment: .leading, spacing: 16 * scaleY) {
                            Text("プレイヤースコア")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(darkGray)
                                .padding(.leading, 20 * scaleX)
                            
                            ForEach(players.indices, id: \.self) { index in
                                PlayerScoreInputRow(
                                    player: $players[index],
                                    rank: index + 1,
                                    maxRank: players.count,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 202 + CGFloat(index) * 76 // 60px高さ + 16px間隔
                                )
                            }
                        }
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        
                        // その他設定（Figma: top: 472px, left: 20px）
                        VStack(alignment: .leading, spacing: 16 * scaleY) {
                            Text("その他設定")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(darkGray)
                                .padding(.leading, 20 * scaleX)
                            
                            // チップ（Figma: top: 502px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("チップ: \(chip)")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Stepper("", value: $chip, in: 0...10000, step: 100)
                                    .frame(width: 353 * scaleX, height: 42 * scaleY)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                    .cornerRadius(8 * scaleX)
                                    .padding(.leading, 20 * scaleX)
                            }
                            
                            // 場代（Figma: top: 572px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("場代: \(tableFee)")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Stepper("", value: $tableFee, in: 0...10000, step: 100)
                                    .frame(width: 353 * scaleX, height: 42 * scaleY)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                    .cornerRadius(8 * scaleX)
                                    .padding(.leading, 20 * scaleX)
                            }
                            
                            // ゲーム代（Figma: top: 642px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("ゲーム代: \(gameFee)")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Stepper("", value: $gameFee, in: 0...10000, step: 100)
                                    .frame(width: 353 * scaleX, height: 42 * scaleY)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                    .cornerRadius(8 * scaleX)
                                    .padding(.leading, 20 * scaleX)
                            }
                        }
                        .padding(.top, 300 * scaleY) // 472 - 172 = 300
                        
                        // 保存ボタン（Figma: top: 742px, left: 20px, width: 353px, height: 60px）
                        Button(action: {
                            Task {
                                await saveGame()
                            }
                        }) {
                            Text("保存")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 353 * scaleX, height: 60 * scaleY)
                                .background(mediumBlue)
                                .cornerRadius(8 * scaleX)
                        }
                        .disabled(!isValid)
                        .padding(.leading, 20 * scaleX)
                        .padding(.top, 670 * scaleY) // 742 - 72 = 670
                    }
                }
            }
        }
        .navigationTitle("スコア入力")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("キャンセル") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            initializePlayers()
        }
    }
    
    private var totalScore: Int {
        players.reduce(0) { $0 + $1.score }
    }
    
    private var totalAmount: Int {
        // スコア計算ロジックを使用
        ScoreCalculator.calculateAmounts(
            players: players.map { PlayerScore(id: $0.id, rank: $0.rank, score: $0.score) },
            rules: rules,
            chip: chip
        ).reduce(0) { $0 + $1.amount }
    }
    
    private var totalAmountWithFee: Int {
        totalAmount + tableFee + gameFee
    }
    
    private var isValid: Bool {
        // 全てのプレイヤーにスコアが入力されているか
        players.allSatisfy { $0.score > 0 } &&
        // 順位が正しく設定されているか
        Set(players.map { $0.rank }).count == players.count
    }
    
    private func initializePlayers() {
        let playerCount = gameType == .threePlayer ? 3 : 4
        players = (0..<playerCount).map { index in
            PlayerInput(id: UUID().uuidString, rank: index + 1, score: 0)
        }
    }
    
    private func saveGame() async {
        let playerScores = players.map { player in
            PlayerScore(id: player.id, rank: player.rank, score: player.score)
        }
        
        let calculatedScores = ScoreCalculator.calculateAmounts(
            players: playerScores,
            rules: rules,
            chip: chip
        )
        
        // 場代・ゲーム代を分配
        let finalScores = ScoreCalculator.distributeFees(
            players: calculatedScores,
            tableFee: tableFee,
            gameFee: gameFee,
            playerCount: players.count
        )
        
        let game = Game(
            id: UUID().uuidString,
            groupId: groupId,
            gameType: gameType,
            date: Date(),
            players: finalScores,
            rate: rules.rate,
            chip: chip,
            tableFee: tableFee,
            gameFee: gameFee,
            rules: rules
        )
        
        do {
            _ = try await FirebaseService.shared.createGame(game: game)
            dismiss()
        } catch {
            print("ゲームの保存に失敗: \(error)")
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

struct PlayerInput: Identifiable {
    let id: String
    var rank: Int
    var score: Int
}

struct PlayerScoreInputRow: View {
    @Binding var player: PlayerInput
    let rank: Int
    let maxRank: Int
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 202 * 1.0
    
    // Figmaデザインのカラー定義
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 202px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // 順位（Figma: top: 222px, left: 35px, 18px, Medium）
            Text("\(rank)位")
                .font(.system(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 35 * scaleX, y: (top + 20) * scaleY) // 222 - 202 = 20
            
            // 順位選択（Figma: top: 222px, left: 100px, width: 100px, height: 42px）
            Picker("順位", selection: $player.rank) {
                ForEach(1...maxRank, id: \.self) { r in
                    Text("\(r)位").tag(r)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 100 * scaleX, height: 42 * scaleY)
            .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
            .cornerRadius(8 * scaleX)
            .position(
                x: 100 * scaleX,
                y: (top + 30) * scaleY
            )
            
            // 点数入力（Figma: top: 222px, left: 220px, width: 133px, height: 42px）
            VStack(alignment: .leading, spacing: 4 * scaleY) {
                Text("点数:")
                    .font(.system(size: 12 * scaleX))
                    .foregroundColor(darkGray.opacity(0.7))
                
                TextField("点数", value: $player.score, format: .number)
                    .keyboardType(.numberPad)
                    .font(.system(size: 16 * scaleX))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8 * scaleX)
                    .frame(width: 133 * scaleX, height: 32 * scaleY)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                    .cornerRadius(8 * scaleX)
            }
            .position(
                x: 220 * scaleX,
                y: (top + 30) * scaleY
            )
        }
    }
}

#Preview {
    ScoreInputView(groupId: nil, gameType: .fourPlayer, rules: GameRules())
}
