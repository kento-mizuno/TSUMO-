//
//  Game.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

enum GameType: String, Codable, CaseIterable {
    case fourPlayer = "4人麻雀"
    case threePlayer = "3人麻雀"
    case free = "フリー麻雀"
}

struct Game: Identifiable, Codable {
    let id: String
    var groupId: String? // nilの場合はフリー麻雀
    var gameType: GameType
    var date: Date
    var players: [PlayerScore]
    var rate: String
    var chip: Int // チップ
    var tableFee: Int // 場代
    var gameFee: Int // ゲーム代
    var rules: GameRules
    let createdAt: Date
    var updatedAt: Date
    
    init(
        id: String,
        groupId: String? = nil,
        gameType: GameType,
        date: Date = Date(),
        players: [PlayerScore],
        rate: String,
        chip: Int = 0,
        tableFee: Int = 0,
        gameFee: Int = 0,
        rules: GameRules
    ) {
        self.id = id
        self.groupId = groupId
        self.gameType = gameType
        self.date = date
        self.players = players
        self.rate = rate
        self.chip = chip
        self.tableFee = tableFee
        self.gameFee = gameFee
        self.rules = rules
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
    }
    
    // フリー麻雀かどうか
    var isFreeGame: Bool {
        return groupId == nil
    }
}
