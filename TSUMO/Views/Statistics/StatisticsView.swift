//
//  StatisticsView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

// ZenMaruGothicフォントのヘルパー関数（Figma: Zen_Maru_Gothic）
func zenMaruGothicFont(size: CGFloat, weight: Font.Weight = .medium) -> Font {
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

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedMonth = Date()
    @State private var selectedFilter: GameFilterType = .all
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let lightPink = Color(red: 0.98, green: 0.95, blue: 0.95) // オフホワイト
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
                    ZStack {
                        // 月選択とフィルター
                        monthAndFilterSection(scaleX: scaleX, scaleY: scaleY, screenWidth: screenWidth)
                        
                        // 月次統計セクション
                        monthlyStatsSection(scaleX: scaleX, scaleY: scaleY)
                        
                        // 順位別統計セクション
                        rankStatsSection(scaleX: scaleX, scaleY: scaleY)
                        
                        // カレンダー表示セクション
                        calendarSection(scaleX: scaleX, scaleY: scaleY)
                        
                        // ランキングセクション
                        rankingSection(scaleX: scaleX, scaleY: scaleY)
                        
                        // 相性分析セクション
                        compatibilitySection(scaleX: scaleX, scaleY: scaleY)
                    }
                    .frame(width: screenWidth, height: 1946 * scaleY) // 1499 + 447 = 1946（最後のカードのbottom）
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadData(month: selectedMonth, filter: selectedFilter)
                }
            }
            .onChange(of: selectedMonth) { newMonth in
                Task {
                    await viewModel.loadData(month: newMonth, filter: selectedFilter)
                }
            }
            .onChange(of: selectedFilter) { newFilter in
                Task {
                    await viewModel.loadData(month: selectedMonth, filter: newFilter)
                }
            }
        }
    }
    
    // 月選択とフィルターセクション
    private func monthAndFilterSection(scaleX: CGFloat, scaleY: CGFloat, screenWidth: CGFloat) -> some View {
        ZStack {
            // 現在の月を取得（年月のみ）
            let calendar = Calendar.current
            let currentDate = Date()
            let currentYear = calendar.component(.year, from: currentDate)
            let currentMonth = calendar.component(.month, from: currentDate)
            let selectedYear = calendar.component(.year, from: selectedMonth)
            let selectedMonthValue = calendar.component(.month, from: selectedMonth)
            
            // 次の月に移動可能かチェック（現在の月より未来でないか）
            let canMoveToNextMonth = selectedYear < currentYear || (selectedYear == currentYear && selectedMonthValue < currentMonth)
            
            // 月選択エリア（スワイプ可能な領域）
            let monthAreaWidth: CGFloat = 250 * scaleX
            let monthAreaHeight: CGFloat = 50 * scaleY
            
            HStack {
                // 左矢印（Figma: left: 90px, top: 80.17px, width: 7.535px, height: 15.203px）
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(zenMaruGothicFont(size: 15.203 * scaleX))
                        .foregroundColor(.white)
                        .frame(width: 7.535 * scaleX, height: 15.203 * scaleY)
                }
                .frame(width: 90 * scaleX)
                
                Spacer()
                
                // 月テキスト（画面中央にセンタリング）- Figma: Zen_Maru_Gothic:Bold
                Text(DateFormatter.monthYearFormatter.string(from: selectedMonth))
                    .font(zenMaruGothicFont(size: 20 * scaleX, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // 右矢印（Figma: left: 297px, top: 80.17px, width: 7.535px, height: 15.203px）
                Button(action: {
                    if canMoveToNextMonth {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                        }
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(zenMaruGothicFont(size: 15.203 * scaleX))
                        .foregroundColor(canMoveToNextMonth ? .white : .white.opacity(0.3))
                        .frame(width: 7.535 * scaleX, height: 15.203 * scaleY)
                }
                .frame(width: 90 * scaleX)
                .disabled(!canMoveToNextMonth)
            }
            .frame(width: screenWidth)
            .position(x: screenWidth / 2, y: 76 * scaleY) // 72 + 4 = 76（中央）
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        if abs(horizontalAmount) > 50 { // 50px以上スワイプした場合
                            if horizontalAmount > 0 {
                                // 右にスワイプ = 前の月
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                                }
                            } else {
                                // 左にスワイプ = 次の月（現在の月より未来でない場合のみ）
                                if canMoveToNextMonth {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                                    }
                                }
                            }
                        }
                    }
            )
            
            // フィルターボタン背景（Figma: rgba(217,217,217,0.3), top: 149px, left: 10px, width: 371px, height: 40px, rounded: 20px）
            RoundedRectangle(cornerRadius: 20 * scaleX)
                .fill(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.3))
                .frame(width: 371 * scaleX, height: 40 * scaleY)
                .position(x: (10 + 371 / 2) * scaleX, y: (149 + 40 / 2) * scaleY)
            
            // 「総合」ボタン（Figma: bg-[#222], top: 149px, left: 10px, width: 93px, height: 40px, テキスト left: 57px中央, top: 157px）
            FilterButton(
                title: "総合",
                isSelected: selectedFilter == .all,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = .all
                    }
                },
                scaleX: scaleX,
                scaleY: scaleY,
                width: 93,
                left: 10,
                top: 149
            )
            
            // 「4人」ボタン（Figma: top: 149px, left: 103px, width: 93px, height: 40px）
            FilterButton(
                title: "4人",
                isSelected: selectedFilter == .fourPlayer,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = .fourPlayer
                    }
                },
                scaleX: scaleX,
                scaleY: scaleY,
                width: 93,
                left: 103,
                top: 149
            )
            
            // 「3人」ボタン（Figma: top: 149px, left: 196px, width: 93px, height: 40px）
            FilterButton(
                title: "3人",
                isSelected: selectedFilter == .threePlayer,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = .threePlayer
                    }
                },
                scaleX: scaleX,
                scaleY: scaleY,
                width: 93,
                left: 196,
                top: 149
            )
            
            // 「フリー」ボタン（Figma: top: 149px, left: 289px, width: 93px, height: 40px）
            FilterButton(
                title: "フリー",
                isSelected: selectedFilter == .free,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = .free
                    }
                },
                scaleX: scaleX,
                scaleY: scaleY,
                width: 93,
                left: 289,
                top: 149
            )
        }
    }
    
    // 月次統計セクション（Figma: top: 205px, 216px高さ, 373px幅, 10px左マージン）
    private func monthlyStatsSection(scaleX: CGFloat, scaleY: CGFloat) -> some View {
        ZStack {
            // 背景（Figma: Rectangle 47, top: 205px, left: 10px, width: 373px, height: 216px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 373 * scaleX, height: 216 * scaleY)
                .position(x: (10 + 373 / 2) * scaleX, y: (205 + 216 / 2) * scaleY)
            
            // 収入（Figma: タイトル top: 224px, left: 28px, 金額 top: 219px, left: 262px, 24px, Medium, #4591d3）
            StatRow(
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
            StatRow(
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
            StatRow(
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
            StatRow(
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
            StatRow(
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
    }
    
    // 順位別統計セクション（Figma: top: 437px, 191px高さ, 373px幅, 10px左マージン）
    private func rankStatsSection(scaleX: CGFloat, scaleY: CGFloat) -> some View {
        ZStack {
            // 背景（Figma: Rectangle 51, top: 437px, left: 10px, width: 373px, height: 191px）
            RoundedRectangle(cornerRadius: 8)
                .fill(lightPink)
                .frame(width: 373 * scaleX, height: 191 * scaleY)
                .position(x: (10 + 373 / 2) * scaleX, y: (437 + 191 / 2) * scaleY)
            
            // 順位ラベル行（Figma: top: 449px, 16px, Medium, 各列の中央位置）
            // 1着（Figma: left: 49.5px中央, top: 449px）
            RankStatColumn(
                rank: "1着",
                count: viewModel.rankCounts[1] ?? 0,
                percentage: viewModel.rankPercentages[1] ?? 0.0,
                scaleX: scaleX,
                scaleY: scaleY,
                centerX: 49.5,
                sectionTop: 437,
                sectionLeft: 10
            )
            
            // 2着（Figma: left: 149px中央, top: 449px）
            RankStatColumn(
                rank: "2着",
                count: viewModel.rankCounts[2] ?? 0,
                percentage: viewModel.rankPercentages[2] ?? 0.0,
                scaleX: scaleX,
                scaleY: scaleY,
                centerX: 149,
                sectionTop: 437,
                sectionLeft: 10
            )
            
            // 3着（Figma: left: 236px中央, top: 449px）
            RankStatColumn(
                rank: "3着",
                count: viewModel.rankCounts[3] ?? 0,
                percentage: viewModel.rankPercentages[3] ?? 0.0,
                scaleX: scaleX,
                scaleY: scaleY,
                centerX: 236,
                sectionTop: 437,
                sectionLeft: 10
            )
            
                // 4着（Figma: left: 332px中央, top: 449px）
                RankStatColumn(
                    rank: "4着",
                    count: viewModel.rankCounts[4] ?? 0,
                    percentage: viewModel.rankPercentages[4] ?? 0.0,
                    scaleX: scaleX,
                    scaleY: scaleY,
                    centerX: 332,
                    sectionTop: 437,
                    sectionLeft: 10
                )
                
                // 区切り線1（Figma: top: 482px, left: 9px, width: 373px）
                Rectangle()
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.13).opacity(0.3))
                    .frame(width: 373 * scaleX, height: 0.5 * scaleY)
                    .position(
                        x: (9 + 373 / 2) * scaleX,
                        y: 482 * scaleY
                    )
            
            // 連帯率（Figma: ラベル top: 582px, left: 50px中央, 値 top: 573px, left: 107px中央, 24px, Medium, 中央揃え）- Zen_Maru_Gothic:Medium
            Text("連帯率")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 60 * scaleX, alignment: .center)
                .position(x: 50 * scaleX, y: 582 * scaleY)
            
            HStack(spacing: 2 * scaleX) {
                Text("\(String(format: "%.1f", viewModel.winRate))")
                    .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
                Text("%")
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
            }
            .frame(width: 70 * scaleX, alignment: .center)
            .position(x: 118 * scaleX, y: 575 * scaleY)
            
            // 平均着順（Figma: ラベル top: 582px, left: 236px中央, 値 top: 573px, left: 301.5px中央, 24px, Medium, 中央揃え）- Zen_Maru_Gothic:Medium
            Text("平均着順")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 80 * scaleX, alignment: .center)
                .position(x: 236 * scaleX, y: 582 * scaleY)
            
            HStack(spacing: 2 * scaleX) {
                Text("\(String(format: "%.1f", viewModel.averageRank))")
                    .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
                Text("位")
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
            }
            .frame(width: 70 * scaleX, alignment: .center)
            .position(x: 314 * scaleX, y: 575 * scaleY)
        }
    }
    
    // カレンダー表示セクション（Figma: top: 644px, 376px高さ, 373px幅, 10px左マージン）
    private func calendarSection(scaleX: CGFloat, scaleY: CGFloat) -> some View {
        ZStack {
            // 背景（Figma: Rectangle 80, top: 644px, left: 10px, width: 373px, height: 376px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 373 * scaleX, height: 376 * scaleY)
                .position(
                    x: (10 + 373 / 2) * scaleX,
                    y: (644 + 376 / 2) * scaleY
                )
            
            // 区切り線2（Figma: top: 691px, left: 9px, width: 373px）
            Rectangle()
                .fill(Color(red: 0.13, green: 0.13, blue: 0.13).opacity(0.3))
                .frame(width: 373 * scaleX, height: 0.5 * scaleY)
                .position(
                    x: (9 + 373 / 2) * scaleX,
                    y: 691 * scaleY
                )
            
            // カレンダー表示
            CalendarGridView(
                calendarData: viewModel.calendarData,
                selectedMonth: selectedMonth,
                scaleX: scaleX,
                scaleY: scaleY,
                sectionTop: 644,
                sectionLeft: 10
            )
        }
    }
    
    // ランキングセクション（Figma: top: 1036px, 447px高さ, 373px幅, 10px左マージン）
    private func rankingSection(scaleX: CGFloat, scaleY: CGFloat) -> some View {
        ZStack {
            // 背景（Figma: Rectangle 65, top: 1036px, left: 10px, width: 373px, height: 447px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 373 * scaleX, height: 447 * scaleY)
                .position(x: (10 + 373 / 2) * scaleX, y: (1036 + 447 / 2) * scaleY)
            
            // タイトル（Figma: top: 1055px, left: 33px, 18px, Medium）
            Text("ランキング")
                    .font(zenMaruGothicFont(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 33 * scaleX, y: 1055 * scaleY)
            
            // グループ選択背景（Figma: top: 1052px, left: 152px, width: 213px, height: 30px）
            RoundedRectangle(cornerRadius: 20 * scaleX)
                .stroke(Color(red: 0.13, green: 0.13, blue: 0.13), lineWidth: 0.3 * scaleX)
                .background(
                    RoundedRectangle(cornerRadius: 20 * scaleX)
                        .fill(Color.white)
                )
                .frame(width: 213 * scaleX, height: 30 * scaleY)
                .position(x: (152 + 213 / 2) * scaleX, y: (1052 + 30 / 2) * scaleY)
            
            // グループ選択（Figma: top: 1052px, left: 152px, width: 213px, height: 30px）
            if !viewModel.groups.isEmpty {
                Picker("グループ", selection: $viewModel.selectedGroupId) {
                    Text("グループを選択").tag(nil as String?)
                    ForEach(viewModel.groups) { group in
                        Text(group.name).tag(group.id as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 213 * scaleX, height: 30 * scaleY)
                .position(
                    x: (152 + 213 / 2) * scaleX,
                    y: (1052 + 30 / 2) * scaleY
                )
                
                // 「ぱつヅモ育英会」テキスト（Figma: top: 1055px, left: 194px, 16px, Medium）
                Text(viewModel.groups.first?.name ?? "")
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
                    .position(x: 194 * scaleX, y: 1055 * scaleY)
                
                // ドロップダウンアイコン（Figma: top: 1064px, left: 333px, width: 15.203px, height: 7.535px）
                Image(systemName: "chevron.down")
                    .font(zenMaruGothicFont(size: 7.535 * scaleX))
                    .foregroundColor(darkGray)
                    .frame(width: 15.203 * scaleX, height: 7.535 * scaleY)
                    .position(x: 333 * scaleX, y: 1064 * scaleY)
            }
            
            // 注釈（Figma: top: 1094px, left: 33px, 16px, Medium, #7a7a7a）- Zen_Maru_Gothic:Medium
            Text("※フリーの成績は含まれません")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(Color(red: 0.48, green: 0.48, blue: 0.48))
                .position(x: 33 * scaleX, y: 1094 * scaleY)
            
            // ランキングリスト（Figma: top: 1141px, 60px高さ, 320px幅, 35px左マージン）
            if let groupId = viewModel.selectedGroupId {
                ForEach(Array(viewModel.rankings.enumerated()), id: \.element.id) { index, ranking in
                    StatisticsRankingRowView(
                        ranking: ranking,
                        scaleX: scaleX,
                        scaleY: scaleY,
                        top: 1141 + CGFloat(index) * 76, // 60px高さ + 16px間隔
                        sectionLeft: 10
                    )
                }
            }
        }
    }
    
    // 相性分析セクション（Figma: top: 1499px, 447px高さ, 373px幅, 10px左マージン）
    private func compatibilitySection(scaleX: CGFloat, scaleY: CGFloat) -> some View {
        ZStack {
            // 背景（Figma: Rectangle 81, top: 1499px, left: 10px, width: 373px, height: 447px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 373 * scaleX, height: 447 * scaleY)
                .position(
                    x: (10 + 373 / 2) * scaleX,
                    y: (1499 + 447 / 2) * scaleY
                )
            
            // タイトル（Figma: top: 1518px, left: 33px, 18px, Medium）
            Text("相性分析")
                    .font(zenMaruGothicFont(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: 33 * scaleX, y: 1518 * scaleY)
            
            // グループ選択背景（Figma: top: 1515px, left: 152px, width: 213px, height: 30px）
            RoundedRectangle(cornerRadius: 20 * scaleX)
                .stroke(Color(red: 0.13, green: 0.13, blue: 0.13), lineWidth: 0.3 * scaleX)
                .background(
                    RoundedRectangle(cornerRadius: 20 * scaleX)
                        .fill(Color.white)
                )
                .frame(width: 213 * scaleX, height: 30 * scaleY)
                .position(x: (152 + 213 / 2) * scaleX, y: (1515 + 30 / 2) * scaleY)
            
            // グループ選択（Figma: top: 1515px, left: 152px, width: 213px, height: 30px）
            if !viewModel.groups.isEmpty {
                Picker("グループ", selection: $viewModel.selectedCompatibilityGroupId) {
                    Text("グループを選択").tag(nil as String?)
                    ForEach(viewModel.groups) { group in
                        Text(group.name).tag(group.id as String?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 213 * scaleX, height: 30 * scaleY)
                .position(
                    x: (152 + 213 / 2) * scaleX,
                    y: (1515 + 30 / 2) * scaleY
                )
                
                // 「ぱつヅモ育英会」テキスト（Figma: top: 1518px, left: 194px, 16px, Medium）
                Text(viewModel.groups.first?.name ?? "")
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
                    .position(x: 194 * scaleX, y: 1518 * scaleY)
                
                // ドロップダウンアイコン（Figma: top: 1527px, left: 333px, width: 15.203px, height: 7.535px）
                Image(systemName: "chevron.down")
                    .font(zenMaruGothicFont(size: 7.535 * scaleX))
                    .foregroundColor(darkGray)
                    .frame(width: 15.203 * scaleX, height: 7.535 * scaleY)
                    .position(x: 333 * scaleX, y: 1527 * scaleY)
            }
            
            // 注釈（Figma: top: 1557px, left: 33px, 16px, Medium, #7a7a7a）- Zen_Maru_Gothic:Medium
            Text("※フリーの成績は含まれません")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(Color(red: 0.48, green: 0.48, blue: 0.48))
                .position(x: 33 * scaleX, y: 1557 * scaleY)
            
            // 相性分析リスト（Figma: top: 1604px, 60px高さ, 320px幅, 35px左マージン）
            if let groupId = viewModel.selectedCompatibilityGroupId {
                ForEach(Array(viewModel.compatibilityData.enumerated()), id: \.element.id) { index, data in
                    CompatibilityRowView(
                        data: data,
                        scaleX: scaleX,
                        scaleY: scaleY,
                        top: 1604 + CGFloat(index) * 76, // 60px高さ + 16px間隔
                        sectionLeft: 10
                    )
                }
                .onAppear {
                    Task {
                        await viewModel.loadCompatibilityAnalysis(groupId: groupId)
                    }
                }
            } else {
                Text("グループを選択してください")
                    .font(zenMaruGothicFont(size: 12 * scaleX))
                    .foregroundColor(.gray)
                    .position(x: 35 * scaleX, y: 1604 * scaleY)
            }
        }
    }
}

// 統計行コンポーネント
struct StatRow: View {
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
            let titleWidth: CGFloat = 220
            Text(title)
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                .frame(width: titleWidth * scaleX, alignment: .leading)
                .position(
                    x: (sectionLeft + 28 + titleWidth / 2) * scaleX,
                    y: titleTop * scaleY
                )
            
            let cardWidth: CGFloat = 373
            let valueWidth: CGFloat = 110
            let rightPadding: CGFloat = 28
            let valueCenterX = sectionLeft + cardWidth - rightPadding - valueWidth / 2
            
            if isTotal {
                // トータルは右揃え（Figma: top: 370px, left: 336px右揃え, width: 74px）
                // 数値とPを一緒に右揃えで配置
                HStack(spacing: 2 * scaleX) {
                    Text(formatAmount(amount))
                        .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(color)
                    Text("P")
                        .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
                .frame(width: valueWidth * scaleX, alignment: .trailing)
                .position(
                    x: valueCenterX * scaleX,
                    y: amountTop * scaleY
                )
            } else {
                // 通常の行（Figma: left: 262px, 24px, Medium）
                // 数値とPを一緒に右揃えで配置
                HStack(spacing: 2 * scaleX) {
                    Text(formatAmount(amount))
                        .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(color)
                    Text("P")
                        .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
                .frame(width: valueWidth * scaleX, alignment: .trailing)
                .position(
                    x: valueCenterX * scaleX,
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

// 順位別統計列コンポーネント
struct RankStatColumn: View {
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
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 40 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + centerX) * scaleX,
                    y: 449 * scaleY
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
                .font(zenMaruGothicFont(size: 24 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 30 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + countCenterX) * scaleX,
                    y: 488 * scaleY
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
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + countLabelCenterX) * scaleX,
                    y: 498 * scaleY
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
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 80 * scaleX, alignment: .center)
                .position(
                    x: (sectionLeft + percentageCenterX) * scaleX,
                    y: 529 * scaleY
                )
        }
    }
}

// フィルターボタンコンポーネント（Figma: 40px高さ, 20px角丸, 16px, Medium）
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let scaleX: CGFloat
    let scaleY: CGFloat
    var width: CGFloat = 93.0 // スケール前の値
    var left: CGFloat = 10.0 // スケール前の値
    var top: CGFloat = 149.0 // スケール前の値
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 背景（Figma: bg-[#222], width: 93px, height: 40px）
                RoundedRectangle(cornerRadius: 20 * scaleX)
                    .fill(isSelected ? Color(red: 0.13, green: 0.13, blue: 0.13) : Color.clear)
                    .frame(width: width * scaleX, height: 40 * scaleY)
                
                // テキスト（上下中央に配置）
                Text(title)
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: width * scaleX, height: 40 * scaleY, alignment: .center)
            }
        }
        .frame(width: width * scaleX, height: 40 * scaleY)
        .position(x: (left + width / 2) * scaleX, y: (top + 40 / 2) * scaleY)
    }
}

// ランキング行コンポーネント（成績表用）
struct StatisticsRankingRowView: View {
    let ranking: PlayerRanking
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 1141 * 1.0 // 行のtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack {
            // 背景（Figma: top: 1141px, left: 35px, width: 320px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 320 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (sectionLeft + 35 + 320 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // アイコン（Figma: top: 1151px, left: 50px, width: 40px, height: 40px）
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40 * scaleX, height: 40 * scaleY)
                .position(
                    x: (sectionLeft + 50 + 20) * scaleX, // 50 + 40/2 = 70
                    y: (top + 10 + 20) * scaleY // 1151 - 1141 = 10, 10 + 40/2 = 30
                )
            
            // 名前（Figma: top: 1158px, left: 100px, 18px, Medium）
            Text(ranking.userName)
                    .font(zenMaruGothicFont(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: (sectionLeft + 100) * scaleX, y: (top + 17) * scaleY) // 1158 - 1141 = 17
            
            // スコア（Figma: top: 1156px, left: 344px右揃え, 20px, Medium）
            Text(formatAmount(ranking.totalScore))
                    .font(zenMaruGothicFont(size: 20 * scaleX, weight: .medium))
                .foregroundColor(ranking.totalScore >= 0 ? mediumBlue : primaryOrange)
                .frame(width: 71 * scaleX, alignment: .trailing)
                .position(
                    x: (sectionLeft + 344 - 71 / 2) * scaleX, // 344px右揃えの中央
                    y: (top + 15) * scaleY // 1156 - 1141 = 15
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

// カレンダーグリッドビュー
struct CalendarGridView: View {
    let calendarData: [CalendarDayData]
    let selectedMonth: Date
    let scaleX: CGFloat
    let scaleY: CGFloat
    var sectionTop: CGFloat = 644 * 1.0 // セクションのtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack {
            // 曜日ヘッダー（Figma: top: 656px, 16px, Medium, 各曜日の中央位置）- Zen_Maru_Gothic:Medium
            // 月（Figma: left: 42px中央, top: 656px）
            Text("月")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 42) * scaleX, y: 656 * scaleY)
            
            // 火（Figma: left: 93px中央, top: 656px）
            Text("火")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 93) * scaleX, y: 656 * scaleY)
            
            // 水（Figma: left: 144px中央, top: 656px）
            Text("水")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 144) * scaleX, y: 656 * scaleY)
            
            // 木（Figma: left: 195px中央, top: 656px）
            Text("木")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 195) * scaleX, y: 656 * scaleY)
            
            // 金（Figma: left: 246px中央, top: 656px）
            Text("金")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 246) * scaleX, y: 656 * scaleY)
            
            // 土（Figma: left: 297px中央, top: 656px）
            Text("土")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 297) * scaleX, y: 656 * scaleY)
            
            // 日（Figma: left: 348px中央, top: 656px）
            Text("日")
                .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .frame(width: 20 * scaleX, alignment: .center)
                .position(x: (sectionLeft + 348) * scaleX, y: 656 * scaleY)
            
            // カレンダーグリッド
            let weeks = generateWeeks()
            ForEach(Array(weeks.enumerated()), id: \.offset) { weekIndex, week in
                ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, day in
                    CalendarDayView(
                        day: day,
                        amount: getAmount(for: day),
                        scaleX: scaleX,
                        scaleY: scaleY,
                        weekIndex: weekIndex,
                        dayIndex: dayIndex,
                        sectionTop: sectionTop,
                        sectionLeft: sectionLeft
                    )
                    .id("week\(weekIndex)-day\(dayIndex)")
                }
            }
        }
    }
    
    private func generateWeeks() -> [[Int]] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedMonth)!.count
        
        var weeks: [[Int]] = []
        var currentWeek: [Int] = []
        
        // 最初の週の空白を追加
        let adjustedFirstWeekday = (firstWeekday + 5) % 7 // 月曜日を0に調整
        for _ in 0..<adjustedFirstWeekday {
            currentWeek.append(0) // 0は空白を表す
        }
        
        // 日付を追加
        for day in 1...daysInMonth {
            currentWeek.append(day)
            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }
        
        // 最後の週の空白を追加
        while currentWeek.count < 7 && !currentWeek.isEmpty {
            currentWeek.append(0)
        }
        if !currentWeek.isEmpty {
            weeks.append(currentWeek)
        }
        
        return weeks
    }
    
    private func getAmount(for day: Int) -> Int? {
        guard day > 0 else { return nil }
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
            return calendarData.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.amount
        }
        return nil
    }
}

// カレンダー日ビュー
struct CalendarDayView: View {
    let day: Int
    let amount: Int?
    let scaleX: CGFloat
    let scaleY: CGFloat
    var weekIndex: Int = 0
    var dayIndex: Int = 0
    var sectionTop: CGFloat = 644 * 1.0
    var sectionLeft: CGFloat = 10 * 1.0
    
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    // 各曜日の中央X位置（Figmaデザインから）
    private let dayCenterX: [CGFloat] = [42, 93, 144, 195, 246, 297, 348]
    
    var body: some View {
        if day > 0 {
            ZStack {
                // 日付（Figma: top: 711px, 16px, Medium, 各曜日の中央位置）
                // 各週のtop位置: 711px, 769px, 827px, 885px, 943px（間隔58px）
                let dayX = sectionLeft + dayCenterX[dayIndex % 7]
                let dayY = sectionTop + 67 + CGFloat(weekIndex) * 58 // 711 - 644 = 67
                
                Text("\(day)")
                    .font(zenMaruGothicFont(size: 16 * scaleX, weight: .medium))
                    .foregroundColor(darkGray)
                    .frame(width: 30 * scaleX, alignment: .center)
                    .position(x: dayX * scaleX, y: dayY * scaleY)
                
                // 金額（Figma: top: 735px, 12px, Medium, 各曜日の中央位置）
                // 金額は日付の下24pxに配置（735 - 711 = 24）
                if let amount = amount, amount != 0 {
                    let amountY = dayY + 24 * scaleY
                    Text(formatAmount(amount))
                        .font(zenMaruGothicFont(size: 12 * scaleX, weight: .medium))
                        .foregroundColor(amount >= 0 ? mediumBlue : primaryOrange)
                        .frame(width: 50 * scaleX, alignment: .center)
                        .position(x: dayX * scaleX, y: amountY * scaleY)
                }
            }
        }
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let absAmount = abs(amount)
        if absAmount >= 10000 {
            return "\(absAmount / 10000)万"
        }
        return "\(absAmount)"
    }
}

// 相性分析行ビュー
struct CompatibilityRowView: View {
    let data: CompatibilityData
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 1604 * 1.0 // 行のtop位置
    var sectionLeft: CGFloat = 10 * 1.0 // セクションのleft位置
    
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack {
            // 背景（Figma: top: 1604px, left: 35px, width: 320px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 320 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (sectionLeft + 35 + 320 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // アイコン（Figma: top: 1614px, left: 50px, width: 40px, height: 40px）
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40 * scaleX, height: 40 * scaleY)
                .position(
                    x: (sectionLeft + 50 + 20) * scaleX, // 50 + 40/2 = 70
                    y: (top + 10 + 20) * scaleY // 1614 - 1604 = 10, 10 + 40/2 = 30
                )
            
            // 名前（Figma: top: 1621px, left: 100px, 18px, Medium）
            Text(data.userName)
                    .font(zenMaruGothicFont(size: 18 * scaleX, weight: .medium))
                .foregroundColor(darkGray)
                .position(x: (sectionLeft + 100) * scaleX, y: (top + 17) * scaleY) // 1621 - 1604 = 17
            
            // スコア（Figma: top: 1619px, left: 344px右揃え, 20px, Medium）
            Text(formatAmount(data.totalScore))
                    .font(zenMaruGothicFont(size: 20 * scaleX, weight: .medium))
                .foregroundColor(data.totalScore >= 0 ? mediumBlue : primaryOrange)
                .frame(width: 71 * scaleX, alignment: .trailing)
                .position(
                    x: (sectionLeft + 344 - 71 / 2) * scaleX, // 344px右揃えの中央
                    y: (top + 15) * scaleY // 1619 - 1604 = 15
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
        StatisticsView()
    }
}
