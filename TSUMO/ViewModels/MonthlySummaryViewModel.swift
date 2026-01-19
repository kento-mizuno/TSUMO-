//
//  MonthlySummaryViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

@MainActor
class MonthlySummaryViewModel: ObservableObject {
    @Published var income = 0
    @Published var expenses = 0
    @Published var net = 0
    @Published var fees = 0
    @Published var total = 0
    @Published var rankCounts: [Int: Int] = [:]
    @Published var rankPercentages: [Int: Double] = [:]
    @Published var averageRank: Double = 0.0
    @Published var winRate: Double = 0.0
    @Published var isLoading = false
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadMonthlyData(date: Date) async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        
        // 選択された月の開始日と終了日を計算
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        do {
            let dataService = DataServiceManager.shared.dataService
            // 全てのゲームを取得
            let allGames = try await dataService.getUserGames(userId: userId, groupId: nil)
            
            // 選択された月のゲームをフィルタリング
            let userGames = allGames.filter { game in
                game.date >= startOfMonth && game.date <= endOfMonth
            }
            
            calculateStatistics(games: userGames, userId: userId)
        } catch {
            print("月次データの読み込みに失敗: \(error)")
        }
        
        isLoading = false
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
}
