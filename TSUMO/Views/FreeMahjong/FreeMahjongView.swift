//
//  FreeMahjongView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct FreeMahjongView: View {
    @StateObject private var viewModel = FreeMahjongViewModel()
    @State private var showGameInput = false
    
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
                        Text("フリー麻雀")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        if viewModel.games.isEmpty {
                            // 空状態（Figma: top: 172px, 中央揃え）
                            VStack(spacing: 20 * scaleY) {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.system(size: 60 * scaleX))
                                    .foregroundColor(darkGray.opacity(0.5))
                                Text("フリー麻雀の記録がありません")
                                    .font(.system(size: 18 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                Text("個人練習の記録を残しましょう")
                                    .font(.system(size: 16 * scaleX))
                                    .foregroundColor(darkGray.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        } else {
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
        }
        .navigationTitle("フリー麻雀")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showGameInput = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showGameInput) {
            GameTypeSelectionView(groupId: nil)
        }
        .onAppear {
            Task {
                await viewModel.loadGames()
            }
        }
    }
}

#Preview {
    NavigationView {
        FreeMahjongView()
    }
}
