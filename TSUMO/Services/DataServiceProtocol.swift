//
//  DataServiceProtocol.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

protocol DataServiceProtocol {
    // MARK: - User Management
    func getCurrentUser() -> User?
    func createUser(user: User) async throws
    func updateUser(user: User) async throws
    func getUser(userId: String) async throws -> User?
    
    // MARK: - Group Management
    func createGroup(group: Group) async throws -> String
    func getGroup(groupId: String) async throws -> Group?
    func getUserGroups(userId: String) async throws -> [Group]
    func updateGroup(group: Group) async throws
    func deleteGroup(groupId: String) async throws
    
    // MARK: - Game Management
    func createGame(game: Game) async throws -> String
    func getGame(gameId: String) async throws -> Game?
    func getUserGames(userId: String, groupId: String?) async throws -> [Game]
    func getGroupGames(groupId: String) async throws -> [Game]
    func updateGame(game: Game) async throws
    func deleteGame(gameId: String) async throws
}
