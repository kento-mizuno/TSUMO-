//
//  MemberRole.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

enum MemberRole: String, Codable {
    case owner  // グループの管理・削除・メンバー追放が可能
    case member // 閲覧・退会のみ可能
}
