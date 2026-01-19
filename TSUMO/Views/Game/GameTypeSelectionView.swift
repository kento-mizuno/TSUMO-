//
//  GameTypeSelectionView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct GameTypeSelectionView: View {
    let groupId: String?
    @Environment(\.dismiss) var dismiss
    @State private var selectedGameType: GameType?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ゲームタイプを選択")
                    .font(.title2)
                    .padding()
                
                ForEach(GameType.allCases, id: \.self) { gameType in
                    Button(action: {
                        selectedGameType = gameType
                    }) {
                        Text(gameType.rawValue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedGameType == gameType ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedGameType == gameType ? .white : .black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("ゲーム入力")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RulesSettingView(groupId: groupId, gameType: selectedGameType ?? .fourPlayer)) {
                        Text("次へ")
                    }
                    .disabled(selectedGameType == nil)
                }
            }
        }
    }
}

#Preview {
    GameTypeSelectionView(groupId: nil)
}
