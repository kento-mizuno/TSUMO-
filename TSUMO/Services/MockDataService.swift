//
//  MockDataService.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

class MockDataService: DataServiceProtocol {
    static let shared = MockDataService()
    
    // モックデータストレージ
    private var users: [String: User] = [:]
    private var groups: [String: Group] = [:]
    private var games: [String: Game] = [:]
    
    private init() {
        setupMockData()
    }
    
    // MARK: - Mock Data Setup
    
    private func setupMockData() {
        // モックユーザー
        let mockUser1 = User(id: "mock-user-001", name: "モックユーザー", email: "mock@example.com")
        let mockUser2 = User(id: "mock-user-002", name: "プレイヤー2", email: "player2@example.com")
        let mockUser3 = User(id: "mock-user-003", name: "プレイヤー3", email: "player3@example.com")
        let mockUser4 = User(id: "mock-user-004", name: "プレイヤー4", email: "player4@example.com")
        
        users[mockUser1.id] = mockUser1
        users[mockUser2.id] = mockUser2
        users[mockUser3.id] = mockUser3
        users[mockUser4.id] = mockUser4
        
        // モックグループ
        let mockGroup1 = Group(
            id: "mock-group-001",
            name: "テストグループ",
            createdBy: mockUser1.id,
            members: [mockUser1.id, mockUser2.id, mockUser3.id, mockUser4.id]
        )
        groups[mockGroup1.id] = mockGroup1
        
        // モックゲーム
        let rules = GameRules()
        let mockGame1 = Game(
            id: "mock-game-001",
            groupId: mockGroup1.id,
            gameType: .fourPlayer,
            date: Date().addingTimeInterval(-86400), // 1日前
            players: [
                PlayerScore(id: mockUser1.id, rank: 1, score: 35000, amount: 15000, totalAmount: 14000),
                PlayerScore(id: mockUser2.id, rank: 2, score: 28000, amount: 5000, totalAmount: 4000),
                PlayerScore(id: mockUser3.id, rank: 3, score: 22000, amount: -5000, totalAmount: -6000),
                PlayerScore(id: mockUser4.id, rank: 4, score: 15000, amount: -15000, totalAmount: -16000)
            ],
            rate: "1-2-3",
            chip: 1000,
            tableFee: 500,
            gameFee: 500,
            rules: rules
        )
        games[mockGame1.id] = mockGame1
        
        let mockGame2 = Game(
            id: "mock-game-002",
            groupId: nil, // フリー麻雀
            gameType: .free,
            date: Date().addingTimeInterval(-172800), // 2日前
            players: [
                PlayerScore(id: mockUser1.id, rank: 2, score: 29000, amount: 3000, totalAmount: 2000),
                PlayerScore(id: mockUser2.id, rank: 1, score: 36000, amount: 17000, totalAmount: 16000),
                PlayerScore(id: mockUser3.id, rank: 3, score: 21000, amount: -6000, totalAmount: -7000),
                PlayerScore(id: mockUser4.id, rank: 4, score: 14000, amount: -14000, totalAmount: -15000)
            ],
            rate: "1-2-3",
            chip: 0,
            tableFee: 0,
            gameFee: 0,
            rules: rules
        )
        games[mockGame2.id] = mockGame2
    }
    
    // MARK: - User Management
    
    func getCurrentUser() -> User? {
        // モックモードでは常にモックユーザーを返す
        return users["mock-user-001"]
    }
    
    func createUser(user: User) async throws {
        users[user.id] = user
        print("🔧 Mock: Created user \(user.name)")
    }
    
    func updateUser(user: User) async throws {
        users[user.id] = user
        print("🔧 Mock: Updated user \(user.name)")
    }
    
    func getUser(userId: String) async throws -> User? {
        return users[userId]
    }
    
    // MARK: - Group Management
    
    func createGroup(group: Group) async throws -> String {
        groups[group.id] = group
        print("🔧 Mock: Created group \(group.name)")
        return group.id
    }
    
    func getGroup(groupId: String) async throws -> Group? {
        return groups[groupId]
    }
    
    func getUserGroups(userId: String) async throws -> [Group] {
        return groups.values.filter { $0.members.contains(userId) }
    }
    
    func updateGroup(group: Group) async throws {
        groups[group.id] = group
        print("🔧 Mock: Updated group \(group.name)")
    }
    
    func deleteGroup(groupId: String) async throws {
        groups.removeValue(forKey: groupId)
        print("🔧 Mock: Deleted group \(groupId)")
    }
    
    // MARK: - Game Management
    
    func createGame(game: Game) async throws -> String {
        games[game.id] = game
        print("🔧 Mock: Created game \(game.id)")
        return game.id
    }
    
    func getGame(gameId: String) async throws -> Game? {
        return games[gameId]
    }
    
    func getUserGames(userId: String, groupId: String? = nil) async throws -> [Game] {
        var userGames = games.values.filter { game in
            game.players.contains { $0.id == userId }
        }
        
        // groupIdでフィルタリング
        if let groupId = groupId {
            userGames = userGames.filter { $0.groupId == groupId }
        } else {
            // groupIdがnilの場合は、フリーゲームのみ
            userGames = userGames.filter { $0.groupId == nil }
        }
        
        // 日付でソート
        return userGames.sorted { $0.date > $1.date }
    }
    
    func getGroupGames(groupId: String) async throws -> [Game] {
        return games.values
            .filter { $0.groupId == groupId }
            .sorted { $0.date > $1.date }
    }
    
    func updateGame(game: Game) async throws {
        games[game.id] = game
        print("🔧 Mock: Updated game \(game.id)")
    }
    
    func deleteGame(gameId: String) async throws {
        games.removeValue(forKey: gameId)
        print("🔧 Mock: Deleted game \(gameId)")
    }
}
