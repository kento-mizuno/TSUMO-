//
//  FreeMahjongViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

@MainActor
class FreeMahjongViewModel: ObservableObject {
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
            // フリーゲームのみ取得（groupIdがnil）
            games = try await dataService.getUserGames(userId: userId, groupId: nil)
                .filter { $0.groupId == nil }
                .sorted { $0.date > $1.date }
        } catch {
            print("フリー麻雀の読み込みに失敗: \(error)")
        }
        
        isLoading = false
    }
}
