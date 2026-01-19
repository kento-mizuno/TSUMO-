//
//  RankingViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

struct PlayerRanking: Identifiable {
    let id: String
    let userName: String
    let rank: Int
    let totalScore: Int
    let userId: String
    
    init(id: String, userName: String, rank: Int, totalScore: Int, userId: String) {
        self.id = id
        self.userName = userName
        self.rank = rank
        self.totalScore = totalScore
        self.userId = userId
    }
}

@MainActor
class RankingViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var rankings: [PlayerRanking] = []
    @Published var isLoading = false
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadGroups() async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        
        do {
            let dataService = DataServiceManager.shared.dataService
            groups = try await dataService.getUserGroups(userId: userId)
        } catch {
            print("グループの読み込みに失敗: \(error)")
        }
        
        isLoading = false
    }
    
    func loadRankings(groupId: String) async {
        isLoading = true
        
        do {
            let dataService = DataServiceManager.shared.dataService
            // グループのゲームを取得（フリーゲームは除外）
            let games = try await dataService.getGroupGames(groupId: groupId)
            
            // グループ情報を取得
            guard let group = try await dataService.getGroup(groupId: groupId) else {
                isLoading = false
                return
            }
            
            // TODO: GroupMemberの取得（現在は簡易実装）
            // 実際の実装では、GroupMemberテーブルからメンバーを取得する必要がある
            // 現在は、ゲームに参加しているプレイヤーから推測
            var memberIds = Set<String>()
            for game in games {
                for player in game.players {
                    memberIds.insert(player.id)
                }
            }
            
            // GroupManagerを使用してランキングを計算
            // 簡易実装のため、GroupMemberは仮で作成
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
            for userId in memberIds {
                if let user = try? await dataService.getUser(userId: userId) {
                    playerNames[userId] = user.name
                } else {
                    playerNames[userId] = "ユーザー\(userId.prefix(8))"
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
        
        isLoading = false
    }
}
