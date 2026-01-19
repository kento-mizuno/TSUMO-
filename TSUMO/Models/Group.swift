//
//  Group.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct Group: Identifiable, Codable {
    let id: String
    var name: String
    let ownerId: String // 作成者のID（権限管理用）
    var inviteToken: String? // 招待用トークン
    var inviteTokenExpiresAt: Date? // トークンの有効期限
    let createdAt: Date
    var updatedAt: Date
    
    // 後方互換性のため、membersを保持（GroupMemberテーブルが主だが、簡易アクセス用）
    var members: [String] {
        // GroupMemberから取得する想定だが、後方互換性のため空配列を返す
        // 実際のメンバー取得はGroupManager経由で行う
        return []
    }
    
    init(id: String, name: String, ownerId: String, inviteToken: String? = nil, inviteTokenExpiresAt: Date? = nil) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.inviteToken = inviteToken
        self.inviteTokenExpiresAt = inviteTokenExpiresAt
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
    }
    
    // 後方互換性のためのinit（createdByを使用）
    init(id: String, name: String, createdBy: String, members: [String] = []) {
        self.id = id
        self.name = name
        self.ownerId = createdBy
        self.inviteToken = nil
        self.inviteTokenExpiresAt = nil
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
    }
    
    // 招待トークンが有効かどうか
    var isInviteTokenValid: Bool {
        guard let token = inviteToken, let expiresAt = inviteTokenExpiresAt else {
            return false
        }
        return Date() < expiresAt
    }
}
