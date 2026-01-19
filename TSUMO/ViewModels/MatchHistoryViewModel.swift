//
//  MatchHistoryViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

@MainActor
class MatchHistoryViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadGames() async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        
        do {
            let dataService = DataServiceManager.shared.dataService
            // 全てのゲームを取得（グループゲームとフリーゲームの両方）
            // getUserGamesで全てのゲームを取得（groupIdをnilにすると全ゲーム）
            let allGames = try await dataService.getUserGames(userId: userId, groupId: nil as String?)
            games = allGames.sorted { $0.date > $1.date }
        } catch {
            print("対戦履歴の読み込みに失敗: \(error)")
        }
        
        isLoading = false
    }
}
