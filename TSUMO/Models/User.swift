//
//  User.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String?
    let createdAt: Date
    var updatedAt: Date
    
    init(id: String, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
    }
}
