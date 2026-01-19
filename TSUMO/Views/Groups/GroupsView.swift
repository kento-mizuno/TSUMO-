//
//  GroupsView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI

struct GroupsView: View {
    @StateObject private var viewModel = GroupsViewModel()
    @State private var showCreateGroup = false
    
    // Figmaデザインのカラー定義
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let lightPink = Color(red: 0.99, green: 0.93, blue: 0.93) // #fdeeec
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
                
                ZStack(alignment: .topLeading) {
                    // タイトル（Figma: top: 72px, left: 197.5px中央, 20px, Bold）
                    Text("グループ")
                        .font(.system(size: 20 * scaleX, weight: .bold))
                        .foregroundColor(.white)
                        .position(x: 197.5 * scaleX, y: 86.5 * scaleY) // 72 + 29/2 = 86.5
                    
                    // 説明文（Figma: top: 172px, 16px, Medium, 中央揃え）
                    VStack(spacing: 0) {
                        Text("ここではグループの作成や、")
                            .font(.system(size: 16 * scaleX, weight: .medium))
                            .foregroundColor(darkGray)
                        Text("メンバーの招待・管理を行います。")
                            .font(.system(size: 16 * scaleX, weight: .medium))
                            .foregroundColor(darkGray)
                    }
                    .position(x: screenWidth / 2, y: 172 * scaleY)
                    
                    // 新規作成ボタン（Figma: top: 242px, left: 20px, width: 353px, height: 60px）
                    // プラスアイコン（Figma: left: 97px, top: 262px, size: 20px）
                    // テキスト（Figma: left: 125px, top: 262px, 18px, Bold）
                    Button(action: {
                        showCreateGroup = true
                    }) {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(mediumBlue)
                                .frame(width: 353 * scaleX, height: 60 * scaleY)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20 * scaleX))
                                .foregroundColor(.white)
                                .position(x: 97 * scaleX, y: 262 * scaleY)
                            
                            Text("新規グループを作成")
                                .font(.system(size: 18 * scaleX, weight: .bold))
                                .foregroundColor(.white)
                                .position(x: 125 * scaleX, y: 262 * scaleY)
                        }
                    }
                    .position(
                        x: (20 + 353 / 2) * scaleX,
                        y: (242 + 60 / 2) * scaleY
                    )
                    
                    // 参加中のグループ（Figma: top: 350px, left: 20px, 16px, Bold）
                    Text("参加中のグループ")
                        .font(.system(size: 16 * scaleX, weight: .bold))
                        .foregroundColor(darkGray)
                        .position(x: 20 * scaleX, y: 350 * scaleY)
                    
                    // グループリスト
                    ScrollView {
                        VStack(spacing: 16 * scaleY) {
                            ForEach(Array(viewModel.groups.enumerated()), id: \.element.id) { index, group in
                                NavigationLink(destination: GroupDetailView(group: group)) {
                                    GroupRowView(
                                        group: group,
                                        scaleX: scaleX,
                                        scaleY: scaleY,
                                        top: 397 + CGFloat(index) * 76 // 60px高さ + 16px間隔
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20 * scaleX)
                        .padding(.top, 47 * scaleY) // 397 - 350 = 47
                    }
                }
            }
        }
        .navigationTitle("グループ")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCreateGroup) {
            CreateGroupView()
        }
        .onAppear {
            Task {
                await viewModel.loadGroups()
            }
        }
    }
}

struct GroupRowView: View {
    let group: Group
    let scaleX: CGFloat
    let scaleY: CGFloat
    var top: CGFloat = 397 * 1.0 // 行のtop位置
    
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景（Figma: top: 397px, left: 20px, width: 353px, height: 60px）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // アイコン（Figma: top: 407px, left: 35px, width: 40px, height: 40px）
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40 * scaleX, height: 40 * scaleY)
                .position(
                    x: 35 * scaleX,
                    y: (top + 10) * scaleY // 407 - 397 = 10
                )
            
            // グループ名（Figma: top: 404px, left: 96.67px, 18px, Bold）
            Text(group.name)
                .font(.system(size: 18 * scaleX, weight: .bold))
                .foregroundColor(darkGray)
                .position(x: 96.67 * scaleX, y: (top + 7) * scaleY) // 404 - 397 = 7
            
            // オーナー名（Figma: top: 432px, left: 97px, 12px, Bold, rgba(34,34,34,0.5)）
            Text("オーナー：\(group.ownerId)")
                .font(.system(size: 12 * scaleX, weight: .bold))
                .foregroundColor(darkGray.opacity(0.5))
                .position(x: 97 * scaleX, y: (top + 35) * scaleY) // 432 - 397 = 35
            
            // 矢印アイコン（Figma: top: 420.17px, left: 343.83px）
            Image(systemName: "chevron.right")
                .font(.system(size: 15.203 * scaleX))
                .foregroundColor(darkGray)
                .position(x: 343.83 * scaleX, y: (top + 23.17) * scaleY) // 420.17 - 397 = 23.17
        }
    }
}

#Preview {
    GroupsView()
}
