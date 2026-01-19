//
//  CreateGroupView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GroupsViewModel()
    @State private var groupName = ""
    @State private var isLoading = false
    
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
                        Text("グループ作成")
                            .font(.system(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 72 * scaleY)
                        
                        // グループ名入力（Figma: top: 172px, left: 20px, width: 353px, height: 42px）
                        VStack(alignment: .leading, spacing: 8 * scaleY) {
                            Text("グループ名")
                                .font(.system(size: 16 * scaleX, weight: .medium))
                                .foregroundColor(darkGray)
                                .padding(.leading, 20 * scaleX)
                            
                            TextField("グループ名", text: $groupName)
                                .font(.system(size: 16 * scaleX))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16 * scaleX)
                                .frame(width: 353 * scaleX, height: 42 * scaleY)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.5))
                                .cornerRadius(8 * scaleX)
                                .padding(.leading, 20 * scaleX)
                        }
                        .padding(.top, 100 * scaleY) // 172 - 72 = 100
                        
                        // 作成ボタン（Figma: top: 242px, left: 20px, width: 353px, height: 60px）
                        Button(action: {
                            Task {
                                isLoading = true
                                do {
                                    _ = try await viewModel.createGroup(name: groupName)
                                    dismiss()
                                } catch {
                                    // エラーハンドリング
                                }
                                isLoading = false
                            }
                        }) {
                            Text("作成")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 353 * scaleX, height: 60 * scaleY)
                                .background(mediumBlue)
                                .cornerRadius(8 * scaleX)
                        }
                        .disabled(groupName.isEmpty || isLoading)
                        .padding(.leading, 20 * scaleX)
                        .padding(.top, 70 * scaleY) // 242 - 172 = 70
                    }
                }
            }
        }
        .navigationTitle("グループ作成")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("キャンセル") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    CreateGroupView()
}
