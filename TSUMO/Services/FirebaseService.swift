//
//  FirebaseService.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseService: DataServiceProtocol {
    static let shared = FirebaseService()
    
    private var db: Firestore?
    private var isAvailable: Bool {
        return FirebaseApp.app() != nil && db != nil
    }
    
    private init() {
        // Firebaseが利用可能な場合のみFirestoreを初期化
        if FirebaseApp.app() != nil {
            db = Firestore.firestore()
        }
    }
    
    // MARK: - Authentication
    
    func configure() {
        // 既にTSUMOAppで初期化されているため、ここでは何もしない
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            db = Firestore.firestore()
        }
    }
    
    // Firebaseが利用可能かチェック
    func isFirebaseAvailable() -> Bool {
        return isAvailable
    }
    
    // MARK: - User Management
    
    func getCurrentUser() -> User? {
        guard isAvailable, let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "ユーザー",
            email: firebaseUser.email
        )
    }
    
    func createUser(user: User) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        try await db.collection("users").document(user.id).setData(from: user)
    }
    
    func updateUser(user: User) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        var updatedUser = user
        updatedUser.updatedAt = Date()
        try await db.collection("users").document(user.id).setData(from: updatedUser, merge: true)
    }
    
    func getUser(userId: String) async throws -> User? {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let document = try await db.collection("users").document(userId).getDocument()
        return try document.data(as: User.self)
    }
    
    // MARK: - Group Management
    
    func createGroup(group: Group) async throws -> String {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let documentRef = try await db.collection("groups").addDocument(from: group)
        return documentRef.documentID
    }
    
    func getGroup(groupId: String) async throws -> Group? {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let document = try await db.collection("groups").document(groupId).getDocument()
        return try document.data(as: Group.self)
    }
    
    func getUserGroups(userId: String) async throws -> [Group] {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let snapshot = try await db.collection("groups")
            .whereField("members", arrayContains: userId)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Group.self) }
    }
    
    func updateGroup(group: Group) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        var updatedGroup = group
        updatedGroup.updatedAt = Date()
        try await db.collection("groups").document(group.id).setData(from: updatedGroup, merge: true)
    }
    
    func deleteGroup(groupId: String) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        try await db.collection("groups").document(groupId).delete()
    }
    
    // MARK: - Game Management
    
    func createGame(game: Game) async throws -> String {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let documentRef = try await db.collection("games").addDocument(from: game)
        return documentRef.documentID
    }
    
    func getGame(gameId: String) async throws -> Game? {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let document = try await db.collection("games").document(gameId).getDocument()
        return try document.data(as: Game.self)
    }
    
    func getUserGames(userId: String, groupId: String? = nil) async throws -> [Game] {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        // まず全てのゲームを取得して、Swift側でフィルタリング
        // Firestoreの配列クエリは複雑なため、この方法を使用
        let snapshot = try await db.collection("games")
            .order(by: "date", descending: true)
            .getDocuments()
        
        let allGames = try snapshot.documents.compactMap { try $0.data(as: Game.self) }
        
        // ユーザーが参加しているゲームをフィルタリング
        let userGames = allGames.filter { game in
            game.players.contains { $0.id == userId }
        }
        
        // groupIdでフィルタリング
        if let groupId = groupId {
            return userGames.filter { $0.groupId == groupId }
        } else {
            // groupIdがnilの場合は、フリーゲームのみ
            return userGames.filter { $0.groupId == nil }
        }
    }
    
    func getGroupGames(groupId: String) async throws -> [Game] {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        let snapshot = try await db.collection("games")
            .whereField("groupId", isEqualTo: groupId)
            .order(by: "date", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Game.self) }
    }
    
    func updateGame(game: Game) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        var updatedGame = game
        updatedGame.updatedAt = Date()
        try await db.collection("games").document(game.id).setData(from: updatedGame, merge: true)
    }
    
    func deleteGame(gameId: String) async throws {
        guard let db = db else {
            throw NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase is not available"])
        }
        try await db.collection("games").document(gameId).delete()
    }
}
