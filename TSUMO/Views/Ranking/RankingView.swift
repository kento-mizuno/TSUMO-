//
//  RankingView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct RankingView: View {
    @StateObject private var viewModel = RankingViewModel()
    @State private var selectedGroupId: String?
    
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
                        Text("ランキング")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // グループ選択（Figma: top: 152px, left: 152px, width: 213px, height: 30px）
                        if !viewModel.groups.isEmpty {
                            Picker("グループ", selection: $selectedGroupId) {
                                Text("グループを選択").tag(nil as String?)
                                ForEach(viewModel.groups) { group in
                                    Text(group.name).tag(group.id as String?)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 213 * scaleX, height: 30 * scaleY)
                            .position(
                                x: (152 + 213 / 2) * scaleX,
                                y: (152 + 30 / 2) * scaleY
                            )
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .position(x: screenWidth / 2, y: 242 * scaleY)
                        } else if let groupId = selectedGroupId {
                            // ランキングリスト（Figma: top: 241px, 60px高さ, 320px幅, 35px左マージン）
                            ForEach(Array(viewModel.rankings.enumerated()), id: \.element.id) { index, ranking in
                                RankingRowView(
                                    ranking: ranking,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    top: 241 + CGFloat(index) * 76, // 60px高さ + 16px間隔
                                    sectionLeft: 10
                                )
                            }
                            .onAppear {
                                Task {
                                    await viewModel.loadRankings(groupId: groupId)
                                }
                            }
                        } else {
                            Text("グループを選択してください")
                                .font(.system(size: 16 * scaleX))
                                .foregroundColor(darkGray.opacity(0.7))
                                .position(x: screenWidth / 2, y: 242 * scaleY)
                        }
                    }
                }
            }
        }
        .navigationTitle("ランキング")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadGroups()
            }
        }
        .onChange(of: selectedGroupId) { newValue in
            if newValue != nil {
                Task {
                    await viewModel.loadRankings(groupId: newValue!)
                }
            }
        }
    }
}

struct RankingRowView: View {
    let ranking: PlayerRanking
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 241 * 1.0 // 行のtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    
    // Figmaデザインのカラー定義
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 241px, left: 35px, width: 320px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 320 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (sectionLeft + 35 + 320 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // 順位（Figma: top: 251px, left: 50px, 18px, Medium）
            Text("\(ranking.rank)位")
                .font(.system(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 50 * scaleX, y: (top + 10) * scaleY) // 251 - 241 = 10
            
            // アイコン（Figma: top: 251px, left: 100px, width: 40px, height: 40px）
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40 * scaleX, height: 40 * scaleY)
                .position(
                    x: 100 * scaleX,
                    y: (top + 20) * scaleY // 251 - 241 = 10, 中央で20
                )
            
            // 名前（Figma: top: 258px, left: 150px, 18px, Medium）
            Text(ranking.userName)
                .font(.system(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 150 * scaleX, y: (top + 17) * scaleY) // 258 - 241 = 17
            
            // スコア（Figma: top: 256px, left: 344px右揃え, 20px, Medium）
            Text(formatAmount(ranking.totalScore))
                .font(.system(size: 20 * scaleX, weight: .medium))
                .foregroundColor(ranking.totalScore >= 0 ? mediumBlue : primaryOrange)
                .frame(width: 71 * scaleX, alignment: .trailing)
                .position(
                    x: (344 + 71 / 2) * scaleX,
                    y: (top + 15) * scaleY // 256 - 241 = 15
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
    RankingView()
}
