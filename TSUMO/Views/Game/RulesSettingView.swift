//
//  RulesSettingView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct RulesSettingView: View {
    let groupId: String?
    let gameType: GameType
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RulesSettingViewModel()
    @State private var rules = GameRules()
    @State private var showScoreInput = false
    
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
                        Text("対局設定")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // ゲーム基本設定（Figma: top: 172px, left: 20px）
                        VStack(alignment: .leading, spacing: 16 * scaleY) {
                            Text("ゲーム基本設定")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(darkGray)
                                .padding(.leading, 20 * scaleX)
                            
                            // レート選択（Figma: top: 202px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("レート")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Picker("レート", selection: $rules.rate) {
                                    Text("1-2-3").tag("1-2-3")
                                    Text("1-2-4").tag("1-2-4")
                                    Text("1-3-5").tag("1-3-5")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 353 * scaleX, height: 42 * scaleY)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                .cornerRadius(8 * scaleX)
                                .padding(.leading, 20 * scaleX)
                            }
                            
                            // ウマ選択（Figma: top: 272px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("ウマ")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Picker("ウマ", selection: $rules.uma) {
                                    Text("10-20").tag("10-20")
                                    Text("5-10").tag("5-10")
                                    Text("20-30").tag("20-30")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 353 * scaleX, height: 42 * scaleY)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                .cornerRadius(8 * scaleX)
                                .padding(.leading, 20 * scaleX)
                            }
                            
                            // トップ賞選択（Figma: top: 342px, left: 20px, width: 353px, height: 42px）
                            VStack(alignment: .leading, spacing: 8 * scaleY) {
                                Text("トップ賞")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .padding(.leading, 20 * scaleX)
                                
                                Picker("トップ賞", selection: $rules.topPrize) {
                                    Text("なし").tag("なし")
                                    Text("1000").tag("1000")
                                    Text("2000").tag("2000")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 353 * scaleX, height: 42 * scaleY)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                .cornerRadius(8 * scaleX)
                                .padding(.leading, 20 * scaleX)
                            }
                        }
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        
                        // 次へボタン（Figma: top: 742px, left: 20px, width: 353px, height: 60px）
                        Button(action: {
                            showScoreInput = true
                        }) {
                            Text("次へ")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 353 * scaleX, height: 60 * scaleY)
                                .background(mediumBlue)
                                .cornerRadius(8 * scaleX)
                        }
                        .padding(.leading, 20 * scaleX)
                        .padding(.top, 670 * scaleY) // 742 - 72 = 670
                    }
                }
            }
        }
        .navigationTitle("対局設定")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("キャンセル") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showScoreInput) {
            ScoreInputView(groupId: groupId, gameType: gameType, rules: rules)
        }
    }
}

#Preview {
    RulesSettingView(groupId: nil, gameType: .fourPlayer)
}
