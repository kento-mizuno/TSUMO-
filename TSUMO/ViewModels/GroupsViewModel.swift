//
//  GroupsViewModel.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation
import FirebaseAuth

@MainActor
class GroupsViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentUserId: String? {
        if AppConfig.shared.isMockMode {
            return "mock-user-001"
        }
        return Auth.auth().currentUser?.uid
    }
    
    func loadGroups() async {
        guard let userId = currentUserId else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let dataService = DataServiceManager.shared.dataService
            groups = try await dataService.getUserGroups(userId: userId)
        } catch {
            errorMessage = "グループの読み込みに失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func createGroup(name: String) async throws -> String {
        guard let userId = currentUserId else {
            throw NSError(domain: "GroupsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "ユーザーが認証されていません"])
        }
        
        let group = Group(
            id: UUID().uuidString,
            name: name,
            createdBy: userId,
            members: [userId]
        )
        
        let dataService = DataServiceManager.shared.dataService
        let groupId = try await dataService.createGroup(group: group)
        await loadGroups()
        return groupId
    }
}
