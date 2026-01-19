//
//  GroupMember.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct GroupMember: Identifiable, Codable {
    let id: String
    let groupId: String
    let userId: String
    var role: MemberRole
    var joinedAt: Date
    
    init(id: String, groupId: String, userId: String, role: MemberRole) {
        self.id = id
        self.groupId = groupId
        self.userId = userId
        self.role = role
        self.joinedAt = Date()
    }
}
