//
//  GroupDetailView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct GroupDetailView: View {
    let group: Group
    @State private var showGameInput = false
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            // Figmaデザインの基準サイズ: 393 x 852
            let designWidth: CGFloat = 393
            let designHeight: CGFloat = 852
            let scaleX = screenWidth / designWidth
            let scaleY = screenHeight / designHeight
            
            ZStack {
                // 背景色（Figma: #eb5844）
                primaryOrange
                    .ignoresSafeArea()
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        // タイトル（Figma: top: 72px, left: 197.5px中央, 20px, Bold）
                        Text(group.name)
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // 対戦を記録ボタン（Figma: top: 172px, left: 20px, width: 353px, height: 60px）
                        Button(action: {
                            showGameInput = true
                        }) {
                            Text("対戦を記録")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 353 * scaleX, height: 60 * scaleY)
                                .background(mediumBlue)
                                .cornerRadius(8 * scaleX)
                        }
                        .padding(.leading, 20 * scaleX)
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                    }
                }
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showGameInput) {
            GameTypeSelectionView(groupId: group.id)
        }
    }
}

#Preview {
    NavigationView {
        GroupDetailView(group: Group(
            id: "test",
            name: "テストグループ",
            createdBy: "user1"
        ))
    }
}
