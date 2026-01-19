//
//  ScoreCalculator.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct ScoreCalculator {
    // レートから基本点を計算
    static func getBasePoints(rate: String) -> [Int] {
        let components = rate.split(separator: "-").compactMap { Int($0) }
        guard components.count >= 3 else {
            return [1000, 2000, 3000] // デフォルト値
        }
        return components
    }
    
    // ウマから順位差を計算
    static func getUma(uma: String) -> [Int] {
        let components = uma.split(separator: "-").compactMap { Int($0) }
        guard components.count >= 2 else {
            return [10000, 20000] // デフォルト値
        }
        return components
    }
    
    // スコアから金額を計算
    static func calculateAmounts(players: [PlayerScore], rules: GameRules, chip: Int) -> [PlayerScore] {
        let basePoints = getBasePoints(rate: rules.rate)
        let uma = getUma(uma: rules.uma)
        
        // 順位でソート
        let sortedPlayers = players.sorted { $0.rank < $1.rank }
        
        var calculatedPlayers: [PlayerScore] = []
        
        for player in sortedPlayers {
            var amount = 0
            let index = player.rank - 1
            
            // 基本点計算（レート）
            if index < basePoints.count {
                amount += basePoints[index]
            }
            
            // ウマ計算
            if index < uma.count {
                amount += uma[index]
            } else if index == uma.count {
                // 最下位の場合（4人麻雀で4位の場合）
                amount -= uma.reduce(0, +) // 他のプレイヤーのウマの合計を引く
            }
            
            // トップ賞（1位のみ）
            if player.rank == 1 && rules.topPrize != "なし" {
                if let topPrize = Int(rules.topPrize) {
                    amount += topPrize
                }
            }
            
            // チップ（1位のみ）
            if player.rank == 1 {
                amount += chip
            }
            
            // 1位順当たり（1位のみ）
            if player.rank == 1 {
                amount += rules.firstPlaceBonus
            }
            
            var calculatedPlayer = player
            calculatedPlayer.amount = amount
            calculatedPlayer.totalAmount = amount
            calculatedPlayers.append(calculatedPlayer)
        }
        
        // 合計が0になるように調整（オカの分配）
        let totalAmount = calculatedPlayers.reduce(0) { $0 + $1.amount }
        if totalAmount != 0 {
            let adjustment = -totalAmount / calculatedPlayers.count
            calculatedPlayers = calculatedPlayers.map { player in
                var updated = player
                updated.amount += adjustment
                updated.totalAmount += adjustment
                return updated
            }
        }
        
        return calculatedPlayers
    }
    
    // 場代・ゲーム代を分配
    static func distributeFees(players: [PlayerScore], tableFee: Int, gameFee: Int, playerCount: Int) -> [PlayerScore] {
        let totalFee = tableFee + gameFee
        let feePerPlayer = totalFee / playerCount
        
        return players.map { player in
            var updatedPlayer = player
            updatedPlayer.totalAmount = player.totalAmount - feePerPlayer
            return updatedPlayer
        }
    }
}
