//
//  GameRules.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct GameRules: Codable {
    // ゲーム基本設定
    var rate: String // "1-2-3", "1-2-4" など
    var uma: String // "10-20", "5-10" など
    var topPrize: String // "なし", "1000" など
    
    // 点数設定
    var startingPoints: Int // 開始持ち点（通常25000）
    var returnPoints: Int // 返し点（通常30000）
    var firstPlaceBonus: Int // 1位順当たり（通常10000）
    
    // ルール設定
    var redDora: Bool // 赤ドラあり
    var flyingEnd: Bool // トビ終了
    var oka: Int // オカ（通常20000）
    var okaPerThousand: Int // オカ（千点単位、通常2000）
    var callBonus: String // 鳴き祝儀（"なし", "1000" など）
    
    init(
        rate: String = "1-2-3",
        uma: String = "10-20",
        topPrize: String = "なし",
        startingPoints: Int = 25000,
        returnPoints: Int = 30000,
        firstPlaceBonus: Int = 10000,
        redDora: Bool = true,
        flyingEnd: Bool = true,
        oka: Int = 20000,
        okaPerThousand: Int = 2000,
        callBonus: String = "なし"
    ) {
        self.rate = rate
        self.uma = uma
        self.topPrize = topPrize
        self.startingPoints = startingPoints
        self.returnPoints = returnPoints
        self.firstPlaceBonus = firstPlaceBonus
        self.redDora = redDora
        self.flyingEnd = flyingEnd
        self.oka = oka
        self.okaPerThousand = okaPerThousand
        self.callBonus = callBonus
    }
}
