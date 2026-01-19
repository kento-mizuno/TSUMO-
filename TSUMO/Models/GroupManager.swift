//
//  GroupManager.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

/// グループ機能のロジックを管理するクラス
class GroupManager {
    static let shared = GroupManager()
    
    private init() {}
    
    // MARK: - 招待トークン管理
    
    /// 24時間有効な招待トークンを生成
    func generateInviteToken() -> (token: String, expiresAt: Date) {
        let token = UUID().uuidString
        let expiresAt = Date().addingTimeInterval(24 * 60 * 60) // 24時間後
        return (token, expiresAt)
    }
    
    /// グループの招待トークンを更新（再生成）
    func regenerateInviteToken(for group: inout Group) {
        let (token, expiresAt) = generateInviteToken()
        group.inviteToken = token
        group.inviteTokenExpiresAt = expiresAt
        group.updatedAt = Date()
    }
    
    /// グループの招待トークンを無効化
    func invalidateInviteToken(for group: inout Group) {
        group.inviteToken = nil
        group.inviteTokenExpiresAt = nil
        group.updatedAt = Date()
    }
    
    /// 招待トークンが有効かどうかをチェック
    func validateInviteToken(_ group: Group) -> Bool {
        return group.isInviteTokenValid
    }
    
    // MARK: - ランキング集計
    
    /// グループ内のメンバーランキングを計算
    /// - Parameters:
    ///   - groupId: グループID
    ///   - games: 対局データの配列
    ///   - members: グループメンバーの配列
    /// - Returns: ユーザーIDと合計スコアのタプルの配列（降順）
    func calculateRanking(
        groupId: String,
        games: [Game],
        members: [GroupMember]
    ) -> [(userId: String, totalScore: Int, userName: String?)] {
        // グループに関連するゲームのみをフィルタリング
        let groupGames = games.filter { $0.groupId == groupId }
        
        // メンバーIDのセットを作成（高速検索用）
        let memberIds = Set(members.map { $0.userId })
        
        // ユーザーごとのスコアを集計
        var userScores: [String: Int] = [:]
        
        for game in groupGames {
            for player in game.players {
                // グループメンバーのみを集計対象とする
                if memberIds.contains(player.id) {
                    userScores[player.id, default: 0] += player.totalAmount
                }
            }
        }
        
        // メンバーIDとユーザー名のマッピングを作成
        let memberMap = Dictionary(uniqueKeysWithValues: members.map { ($0.userId, nil as String?) })
        
        // スコアで降順ソート
        let sortedRanking = userScores
            .map { (userId: $0.key, totalScore: $0.value, userName: memberMap[$0.key] ?? nil) }
            .sorted { $0.totalScore > $1.totalScore }
        
        return sortedRanking
    }
    
    // MARK: - 権限管理
    
    /// ユーザーがグループのオーナーかどうかを判定
    func isOwner(userId: String, group: Group) -> Bool {
        return group.ownerId == userId
    }
    
    /// ユーザーがグループのオーナーかどうかを判定（GroupMemberから）
    func isOwner(userId: String, member: GroupMember) -> Bool {
        return member.role == .owner
    }
    
    /// ユーザーがグループのメンバーかどうかを判定
    func isMember(userId: String, members: [GroupMember]) -> Bool {
        return members.contains { $0.userId == userId }
    }
    
    /// オーナーが退会可能かどうかを判定（他のメンバーがいる場合は不可）
    func canOwnerLeave(members: [GroupMember]) -> Bool {
        // オーナー以外のメンバーがいる場合は退会不可
        return members.filter { $0.role != .owner }.isEmpty
    }
    
    /// オーナー権限を別のメンバーに譲渡
    func transferOwnership(
        from currentOwnerId: String,
        to newOwnerId: String,
        members: inout [GroupMember]
    ) throws {
        // 現在のオーナーを探す
        guard let currentOwnerIndex = members.firstIndex(where: { $0.userId == currentOwnerId && $0.role == .owner }) else {
            throw GroupManagerError.ownerNotFound
        }
        
        // 新しいオーナーを探す
        guard let newOwnerIndex = members.firstIndex(where: { $0.userId == newOwnerId }) else {
            throw GroupManagerError.memberNotFound
        }
        
        // 権限を変更
        members[currentOwnerIndex].role = .member
        members[newOwnerIndex].role = .owner
    }
}

// MARK: - Errors

enum GroupManagerError: Error, LocalizedError {
    case ownerNotFound
    case memberNotFound
    case invalidInviteToken
    case alreadyMember
    case cannotLeaveAsOwner
    
    var errorDescription: String? {
        switch self {
        case .ownerNotFound:
            return "オーナーが見つかりません"
        case .memberNotFound:
            return "メンバーが見つかりません"
        case .invalidInviteToken:
            return "招待リンクが無効または期限切れです"
        case .alreadyMember:
            return "既にグループのメンバーです"
        case .cannotLeaveAsOwner:
            return "オーナーは他のメンバーに権限を譲渡する必要があります"
        }
    }
}
