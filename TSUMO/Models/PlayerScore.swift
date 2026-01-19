//
//  PlayerScore.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct PlayerScore: Identifiable, Codable {
    let id: String // User ID
    var rank: Int // 順位（1位、2位、3位、4位）
    var score: Int // 点数
    var amount: Int // 金額（チップ、場代込み前）
    var totalAmount: Int // 最終金額（場代・ゲーム代込み）
    
    init(id: String, rank: Int, score: Int, amount: Int = 0, totalAmount: Int = 0) {
        self.id = id
        self.rank = rank
        self.score = score
        self.amount = amount
        self.totalAmount = totalAmount
    }
}
