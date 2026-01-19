//
//  MonthlySummaryView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

// ZenMaruGothicフォントのヘルパー関数（Figma: Zen_Maru_Gothic）
func zenMaruGothicFontForMonthlySummary(size: CGFloat, weight: Font.Weight = .medium) -> Font {
    let fontName: String
    switch weight {
    case .bold:
        fontName = "ZenMaruGothic-Bold"
    case .medium:
        fontName = "ZenMaruGothic-Medium"
    case .regular:
        fontName = "ZenMaruGothic-Regular"
    case .light:
        fontName = "ZenMaruGothic-Light"
    case .black:
        fontName = "ZenMaruGothic-Black"
    default:
        fontName = "ZenMaruGothic-Medium"
    }
    
    if let font = UIFont(name: fontName, size: size) {
        return Font(font)
    }
    
    // フォントが見つからない場合はシステムフォントを使用
    return .system(size: size, weight: weight)
}

struct MonthlySummaryView: View {
    @StateObject private var viewModel = MonthlySummaryViewModel()
    @State private var selectedDate = Date()
    
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
                        Text(DateFormatter.yearMonthFormatter.string(from: selectedDate))
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // 月選択（Figma: top: 152px, left: 20px, width: 353px, height: 40px）
                        DatePicker("月を選択", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .frame(width: 353 * scaleX, height: 40 * scaleY)
                            .position(
                                x: (20 + 353 / 2) * scaleX,
                                y: (152 + 40 / 2) * scaleY
                            )
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .position(x: screenWidth / 2, y: 242 * scaleY)
                        } else {
                            // 収支サマリー（StatisticsViewの月次統計セクションと同じレイアウト）
                            // Figma: Rectangle 47, top: 205px, left: 10px, width: 373px, height: 216px
                            ZStack {
                                // 背景（Figma: top: 205px, left: 10px, width: 373px, height: 216px）
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 373 * scaleX, height: 216 * scaleY)
                                    .position(x: (10 + 373 / 2) * scaleX, y: (205 + 216 / 2) * scaleY)
                                
                                // 収入（Figma: タイトル top: 224px, left: 28px, 金額 top: 219px, left: 262px, 24px, Medium, #4591d3）
                                StatRowForMonthly(
                                    title: "収入",
                                    amount: viewModel.income,
                                    color: mediumBlue,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    titleTop: 224,
                                    amountTop: 219,
                                    sectionLeft: 10
                                )
                                
                                // 支出（Figma: タイトル top: 262px, left: 28px, 金額 top: 256px, left: 262px, 24px, Medium, #eb5844）
                                StatRowForMonthly(
                                    title: "支出",
                                    amount: viewModel.expenses,
                                    color: primaryOrange,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    titleTop: 262,
                                    amountTop: 256,
                                    sectionLeft: 10
                                )
                                
                                // 差し引き（Figma: タイトル top: 300px, left: 28px, 金額 top: 294px, left: 262px, 24px, Medium, #4591d3）
                                StatRowForMonthly(
                                    title: "差し引き",
                                    amount: viewModel.net,
                                    color: mediumBlue,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    titleTop: 300,
                                    amountTop: 294,
                                    sectionLeft: 10
                                )
                                
                                // 場代・ゲーム代（Figma: タイトル top: 338px, left: 28px, 金額 top: 332px, left: 262px, 24px, Medium, #222）
                                StatRowForMonthly(
                                    title: "場代・ゲーム代",
                                    amount: viewModel.fees,
                                    color: darkGray,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    titleTop: 338,
                                    amountTop: 332,
                                    sectionLeft: 10
                                )
                                
                                // トータル（Figma: タイトル top: 376px, left: 28px, 金額 top: 370px, left: 336px右揃え, 24px, Medium）
                                StatRowForMonthly(
                                    title: "トータル",
                                    amount: viewModel.total,
                                    color: viewModel.total >= 0 ? mediumBlue : primaryOrange,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    titleTop: 376,
                                    amountTop: 370,
                                    sectionLeft: 10,
                                    isTotal: true
                                )
                            }
                            .padding(.top, 53 * scaleY) // 205 - 152 = 53
                            
                            // 順位別ゲーム数（StatisticsViewの順位別統計セクションと同じレイアウト）
                            ZStack(alignment: .topLeading) {
                                // 背景（Figma: top: 437px, left: 10px, width: 373px, height: 191px）
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 373 * scaleX, height: 191 * scaleY)
                                    .position(
                                        x: (10 + 373 / 2) * scaleX,
                                        y: (437 + 191 / 2) * scaleY
                                    )
                                
                                // 順位ラベル行（Figma: top: 449px, 16px, Medium, 各列の中央位置）
                                RankStatColumnForMonthly(
                                    rank: "1着",
                                    count: viewModel.rankCounts[1] ?? 0,
                                    percentage: viewModel.rankPercentages[1] ?? 0.0,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    centerX: 49.5,
                                    sectionTop: 437,
                                    sectionLeft: 10
                                )
                                
                                RankStatColumnForMonthly(
                                    rank: "2着",
                                    count: viewModel.rankCounts[2] ?? 0,
                                    percentage: viewModel.rankPercentages[2] ?? 0.0,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    centerX: 149,
                                    sectionTop: 437,
                                    sectionLeft: 10
                                )
                                
                                RankStatColumnForMonthly(
                                    rank: "3着",
                                    count: viewModel.rankCounts[3] ?? 0,
                                    percentage: viewModel.rankPercentages[3] ?? 0.0,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    centerX: 236,
                                    sectionTop: 437,
                                    sectionLeft: 10
                                )
                                
                                RankStatColumnForMonthly(
                                    rank: "4着",
                                    count: viewModel.rankCounts[4] ?? 0,
                                    percentage: viewModel.rankPercentages[4] ?? 0.0,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    centerX: 332,
                                    sectionTop: 437,
                                    sectionLeft: 10
                                )
                                
                                // 区切り線（Figma: top: 482px, left: 9px, width: 373px）
                                Rectangle()
                                    .fill(Color(red: 0.13, green: 0.13, blue: 0.13).opacity(0.3))
                                    .frame(width: 373 * scaleX, height: 0.5 * scaleY)
                                    .position(
                                        x: (9 + 373 / 2) * scaleX,
                                        y: 482 * scaleY
                                    )
                                
                                // 連帯率（Figma: ラベル top: 582px, left: 50px中央, 値 top: 573px, left: 107px中央）
                                Text("連帯率")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 50 * scaleX, y: 582 * scaleY)
                                
                                Text("\(String(format: "%.1f", viewModel.winRate))")
                                    .font(.system(size: 24 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 107 * scaleX, y: 573 * scaleY)
                                
                                Text("%")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 136.5 * scaleX, y: 583 * scaleY)
                                
                                // 平均着順（Figma: ラベル top: 582px, left: 236px中央, 値 top: 573px, left: 301.5px中央）
                                Text("平均着順")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 236 * scaleX, y: 582 * scaleY)
                                
                                Text("\(String(format: "%.1f", viewModel.averageRank))")
                                    .font(.system(size: 24 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 301.5 * scaleX, y: 573 * scaleY)
                                
                                Text("位")
                                    .font(.system(size: 16 * scaleX, weight: .medium))
                                    .foregroundColor(darkGray)
                                    .position(x: 328 * scaleX, y: 583 * scaleY)
                            }
                            .padding(.top, 285 * scaleY) // 437 - 152 = 285
                        }
                    }
                }
            }
        }
        .navigationTitle(DateFormatter.yearMonthFormatter.string(from: selectedDate))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadMonthlyData(date: selectedDate)
            }
        }
        .onChange(of: selectedDate) { newDate in
            Task {
                await viewModel.loadMonthlyData(date: newDate)
            }
        }
    }
}

// StatRowコンポーネント（StatisticsViewと同じ実装）
struct StatRowForMonthly: View {
    let title: String
    let amount: Int
    let color: Color
    let scaleX: CGFloat
    let scaleY: CGFloat
    var titleTop: CGFloat = 224 * 1.0 // タイトルのtop位置
    var amountTop: CGFloat = 219 * 1.0 // 金額のtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    var isTotal: Bool = false
    
    var body: some View {
        ZStack {
            // タイトル（Figma: left: 28px, 16px, Medium）- Zen_Maru_Gothic:Medium
            Text(title)
                .font(zenMaruGothicFontForMonthlySummary(size: 16 * scaleX, weight: .medium))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                .position(
                    x: (sectionLeft + 28) * scaleX,
                    y: titleTop * scaleY
                )
            
            if isTotal {
                // トータルは右揃え（Figma: top: 370px, left: 336px右揃え, width: 74px）
                // 数値とPを一緒に右揃えで配置
                HStack(spacing: 2 * scaleX) {
                    Text(formatAmount(amount))
                        .font(zenMaruGothicFontForMonthlySummary(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(color)
                    Text("P")
                        .font(zenMaruGothicFontForMonthlySummary(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
                .frame(width: 87 * scaleX, alignment: .trailing) // 74px + 13px (Pの幅)
                .position(
                    x: (sectionLeft + 336 - 87 / 2) * scaleX, // 336px右揃えの中央
                    y: amountTop * scaleY
                )
            } else {
                // 通常の行（Figma: left: 262px, 24px, Medium）
                // 数値とPを一緒に右揃えで配置
                HStack(spacing: 2 * scaleX) {
                    Text(formatAmount(amount))
                        .font(zenMaruGothicFontForMonthlySummary(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(color)
                    Text("P")
                        .font(zenMaruGothicFontForMonthlySummary(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
                .frame(width: 87 * scaleX, alignment: .trailing) // 数値幅 + Pの幅
                .position(
                    x: (sectionLeft + 262 + 87 / 2) * scaleX, // 262pxから右揃え
                    y: amountTop * scaleY
                )
            }
        }
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }
}

// RankStatColumnコンポーネント（StatisticsViewと同じ実装）
struct RankStatColumnForMonthly: View {
    let rank: String
    let count: Int
    let percentage: Double
    let scaleX: CGFloat
    let scaleY: CGFloat
    var centerX: CGFloat = 49.5 * 1.0 // 列の中央X位置
    var sectionTop: CGFloat = 437 * 1.0 // セクションのtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack {
            // 順位名（Figma: top: 449px, 16px, Medium, 中央揃え）- Zen_Maru_Gothic:Medium
            Text(rank)
                .font(zenMaruGothicFontForMonthlySummary(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 40 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + centerX) * scaleX,
                    y: (sectionTop + 12) * scaleY // 449 - 437 = 12
                )
            
            // 回数（Figma: top: 488px, 24px, Medium, 中央揃え）
            // 1着: left: 46.5px中央, 2着: left: 140.5px中央, 3着: left: 227px中央, 4着: left: 323px中央
            let countCenterX: CGFloat = {
                switch rank {
                case "1着": return 46.5
                case "2着": return 140.5
                case "3着": return 227
                case "4着": return 323
                default: return centerX
                }
            }()
            
            Text("\(count)")
                .font(zenMaruGothicFontForMonthlySummary(size: 24 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 30 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + countCenterX) * scaleX,
                    y: (sectionTop + 51) * scaleY // 488 - 437 = 51
                )
            
            // 「回」テキスト（Figma: top: 498px, 16px, Medium, 中央揃え）
            // 1着: left: 66px中央, 2着: left: 160px中央, 3着: left: 247px中央, 4着: left: 343px中央
            let countLabelCenterX: CGFloat = {
                switch rank {
                case "1着": return 66
                case "2着": return 160
                case "3着": return 247
                case "4着": return 343
                default: return centerX
                }
            }()
            
            Text("回")
                .font(zenMaruGothicFontForMonthlySummary(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + countLabelCenterX) * scaleX,
                    y: (sectionTop + 61) * scaleY // 498 - 437 = 61
                )
            
            // パーセンテージ（Figma: top: 529px, 16px, Medium, 中央揃え）
            // 1着: left: 53px中央, 2着: left: 149px中央, 3着: left: 236px中央, 4着: left: 332px中央
            let percentageCenterX: CGFloat = {
                switch rank {
                case "1着": return 53
                case "2着": return 149
                case "3着": return 236
                case "4着": return 332
                default: return centerX
                }
            }()
            
            Text("(\(String(format: "%.1f", percentage))%)")
                .font(zenMaruGothicFontForMonthlySummary(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 80 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + percentageCenterX) * scaleX,
                    y: (sectionTop + 92) * scaleY // 529 - 437 = 92
                )
        }
    }
}

#Preview {
    MonthlySummaryView()
}
