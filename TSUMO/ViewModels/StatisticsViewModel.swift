//
//  StatisticsViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

enum GameFilterType {
    case all
    case fourPlayer
    case threePlayer
    case free
}

struct CalendarDayData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Int
}

struct CompatibilityData: Identifiable {
    let id = UUID()
    let userId: String
    let userName: String
    let totalScore: Int
}

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var income = 0
    @Published var expenses = 0
    @Published var net = 0
    @Published var fees = 0
    @Published var total = 0
    @Published var rankCounts: [Int: Int] = [:]
    @Published var rankPercentages: [Int: Double] = [:]
    @Published var averageRank: Double = 0.0
    @Published var winRate: Double = 0.0
    @Published var rankings: [PlayerRanking] = []
    @Published var groups: [Group] = []
    @Published var selectedGroupId: String? {
        didSet {
            if let groupId = selectedGroupId {
                Task {
                    await loadRankings(groupId: groupId)
                }
            }
        }
    }
    @Published var selectedCompatibilityGroupId: String? {
        didSet {
            if let groupId = selectedCompatibilityGroupId {
                Task {
                    await loadCompatibilityAnalysis(groupId: groupId)
                }
            }
        }
    }
    @Published var calendarData: [CalendarDayData] = []
    @Published var compatibilityData: [CompatibilityData] = []
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = DataServiceManager.shared.dataService) {
        self.dataService = dataService
    }
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadData(month: Date, filter: GameFilterType) async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        
        // 選択された月の開始日と終了日を計算
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        do {
            // 全てのゲームを取得
            let allGames = try await dataService.getUserGames(userId: userId, groupId: nil)
            
            // 選択された月のゲームをフィルタリング
            var filteredGames = allGames.filter { game in
                game.date >= startOfMonth && game.date <= endOfMonth
            }
            
            // フィルタータイプでさらにフィルタリング
            switch filter {
            case .all:
                break // 全てのゲーム
            case .fourPlayer:
                filteredGames = filteredGames.filter { $0.gameType == .fourPlayer }
            case .threePlayer:
                filteredGames = filteredGames.filter { $0.gameType == .threePlayer }
            case .free:
                filteredGames = filteredGames.filter { $0.isFreeGame }
            }
            
            // 統計を計算
            calculateStatistics(games: filteredGames, userId: userId)
            
            // グループを読み込む
            await loadGroups()
            
            // 選択されたグループのランキングを読み込む
            if let groupId = selectedGroupId {
                await loadRankings(groupId: groupId)
            }
            
            // カレンダーデータを生成
            generateCalendarData(games: filteredGames, userId: userId, month: month)
        } catch {
            print("統計データの読み込みに失敗: \(error)")
        }
        
        isLoading = false
    }
    
    private func generateCalendarData(games: [Game], userId: String, month: Date) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        var dayDataMap: [Date: Int] = [:]
        
        for game in games {
            if let playerScore = game.players.first(where: { $0.id == userId }) {
                let day = calendar.startOfDay(for: game.date)
                if day >= startOfMonth && day <= endOfMonth {
                    dayDataMap[day, default: 0] += playerScore.totalAmount
                }
            }
        }
        
        var calendarData: [CalendarDayData] = []
        var currentDate = startOfMonth
        
        while currentDate <= endOfMonth {
            let amount = dayDataMap[currentDate] ?? 0
            calendarData.append(CalendarDayData(date: currentDate, amount: amount))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        self.calendarData = calendarData
    }
    
    func loadCompatibilityAnalysis(groupId: String) async {
        // 相性分析の実装（後で詳細を実装）
        // 現在は空のデータを返す
        compatibilityData = []
    }
    
    private func calculateStatistics(games: [Game], userId: String) {
        var totalIncome = 0
        var totalExpenses = 0
        var totalFees = 0
        var rankCounts: [Int: Int] = [:]
        var totalRank = 0
        var winCount = 0
        
        for game in games {
            if let playerScore = game.players.first(where: { $0.id == userId }) {
                if playerScore.totalAmount > 0 {
                    totalIncome += playerScore.totalAmount
                } else {
                    totalExpenses += abs(playerScore.totalAmount)
                }
                
                totalFees += game.tableFee + game.gameFee
                
                rankCounts[playerScore.rank, default: 0] += 1
                totalRank += playerScore.rank
                
                if playerScore.rank == 1 {
                    winCount += 1
                }
            }
        }
        
        income = totalIncome
        expenses = totalExpenses
        net = totalIncome - totalExpenses
        fees = totalFees
        total = net - fees
        self.rankCounts = rankCounts
        
        // パーセンテージを計算
        let totalGames = games.count
        if totalGames > 0 {
            rankPercentages = rankCounts.mapValues { Double($0) / Double(totalGames) * 100.0 }
            averageRank = Double(totalRank) / Double(totalGames)
            winRate = Double(winCount) / Double(totalGames) * 100.0
        } else {
            rankPercentages = [:]
            averageRank = 0.0
            winRate = 0.0
        }
    }
    
    func loadGroups() async {
        guard let userId = currentUserId else { return }
        
        do {
            groups = try await dataService.getUserGroups(userId: userId)
            // 最初のグループを選択
            if selectedGroupId == nil && !groups.isEmpty {
                selectedGroupId = groups.first?.id
            }
        } catch {
            print("グループの読み込みに失敗: \(error)")
        }
    }
    
    func loadRankings(groupId: String) async {
        do {
            // グループ情報を取得
            guard let group = try await dataService.getGroup(groupId: groupId) else {
                print("グループが見つかりません")
                return
            }
            
            // グループのゲームを取得（フリーゲームは除外）
            let games = try await dataService.getGroupGames(groupId: groupId)
            
            // グループメンバーのIDを抽出
            var memberIds: Set<String> = []
            for game in games {
                for player in game.players {
                    memberIds.insert(player.id)
                }
            }
            
            // GroupManagerを使用してランキングを計算
            let members = memberIds.map { userId in
                GroupMember(
                    id: UUID().uuidString,
                    groupId: groupId,
                    userId: userId,
                    role: userId == group.ownerId ? .owner : .member
                )
            }
            
            let rankingData = GroupManager.shared.calculateRanking(
                groupId: groupId,
                games: games,
                members: members
            )
            
            // ユーザー名を取得
            var playerNames: [String: String] = [:]
            for member in members {
                if let user = try await dataService.getUser(userId: member.userId) {
                    playerNames[member.userId] = user.name
                } else {
                    playerNames[member.userId] = "ユーザー\(member.userId.prefix(8))"
                }
            }
            
            // ランキングを作成
            rankings = rankingData.enumerated().map { index, element in
                PlayerRanking(
                    id: element.userId,
                    userName: element.userName ?? playerNames[element.userId] ?? "ユーザー",
                    rank: index + 1,
                    totalScore: element.totalScore,
                    userId: element.userId
                )
            }
        } catch {
            print("ランキングの読み込みに失敗: \(error)")
        }
    }
}
