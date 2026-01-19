//
//  MyPageViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

@MainActor
class MyPageViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var totalGames = 0
    @Published var averageRank: Double = 0.0
    @Published var totalBalance = 0
    @Published var isLoading = false
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadData() async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        
        let dataService = DataServiceManager.shared.dataService
        
        // ユーザー情報を取得
        do {
            currentUser = try await dataService.getUser(userId: userId)
        } catch {
            print("ユーザー情報の取得に失敗: \(error)")
        }
        
        // ゲームデータを取得して統計を計算
        do {
            let games = try await dataService.getUserGames(userId: userId, groupId: nil)
            calculateStatistics(games: games, userId: userId)
        } catch {
            print("ゲームデータの取得に失敗: \(error)")
        }
        
        isLoading = false
    }
    
    private func calculateStatistics(games: [Game], userId: String) {
        totalGames = games.count
        
        if totalGames > 0 {
            // 平均順位を計算
            let totalRank = games.reduce(0) { sum, game in
                if let playerScore = game.players.first(where: { $0.id == userId }) {
                    return sum + playerScore.rank
                }
                return sum
            }
            averageRank = Double(totalRank) / Double(totalGames)
            
            // 総合収支を計算
            totalBalance = games.reduce(0) { sum, game in
                if let playerScore = game.players.first(where: { $0.id == userId }) {
                    return sum + playerScore.totalAmount
                }
                return sum
            }
        }
    }
}
