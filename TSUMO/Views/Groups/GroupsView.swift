//
//  GroupsView.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import SwiftUI
import UIKit

// ZenMaruGothicフォントのヘルパー関数
func zenMaruGothicFontForGroups(size: CGFloat, weight: Font.Weight = .medium) -> Font {
    let fontName: String
    switch weight {
    case .bold:
        fontName = "ZenMaruGothic-Bold"
    case .medium:
        fontName = "ZenMaruGothic-Medium"
    case .regular:
        fontName = "ZenMaruGothic-Regular"
    case .light:
        fontName = "ZenMaruGothic-Light"
    case .black:
        fontName = "ZenMaruGothic-Black"
    default:
        fontName = "ZenMaruGothic-Medium"
    }
    
    if let font = UIFont(name: fontName, size: size) {
        return Font(font)
    }
    
    return .system(size: size, weight: weight)
}

struct GroupsView: View {
    @StateObject private var viewModel = GroupsViewModel()
    @State private var showCreateGroup = false
    
    // Figmaデザインのカラー定義（node-id=27-5308）
    private let primaryOrange = Color(red: 0.92, green: 0.35, blue: 0.27) // #eb5844
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    private let lightPink = Color(red: 0.99, green: 0.93, blue: 0.93) // #fdeeec
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    private let lightGray = Color(red: 0.48, green: 0.48, blue: 0.48) // #7a7a7a
    
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
                // 背景色（オレンジ）- Figma: bg-[#eb5844]
                primaryOrange
                    .ignoresSafeArea()
                
                // ピンクのコンテンツエリア - Figma: top: 125px, rounded-tl-[80px] rounded-tr-[80px]
                RoundedRectangle(cornerRadius: 80 * scaleX)
                    .fill(lightPink)
                    .frame(width: screenWidth, height: screenHeight - 125 * scaleY)
                    .position(
                        x: screenWidth / 2,
                        y: (125 + (screenHeight - 125 * scaleY) / 2) * scaleY
                    )
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        // タイトル - Figma: top: 72px, left: 179px (中央), 20px, Bold, white
                        Text("グループ")
                            .font(zenMaruGothicFontForGroups(size: 20 * scaleX, weight: .bold))
                            .foregroundColor(.white)
                            .position(
                                x: 179 * scaleX, // 中央: 393/2 = 196.5, でもFigmaでは179px
                                y: 72 * scaleY
                            )
                        
                        // アイコン - Figma: Group13, left: 226px, top: 79px, width: 27.407px, height: 17.03px
                        // TSUMO_5_2を使用
                        Image("TSUMO_5_2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 27.407 * scaleX, height: 17.03 * scaleY)
                            .position(
                                x: (226 + 27.407 / 2) * scaleX,
                                y: (79 + 17.03 / 2) * scaleY
                            )
                        
                        // 説明文 - Figma: top: 172px, left: 197px (中央), 16px, Medium, 中央揃え
                        VStack(spacing: 0) {
                            Text("ここではグループの作成や、")
                                .font(zenMaruGothicFontForGroups(size: 16 * scaleX, weight: .medium))
                                .foregroundColor(darkGray)
                            Text("メンバーの招待・管理を行います。")
                                .font(zenMaruGothicFontForGroups(size: 16 * scaleX, weight: .medium))
                                .foregroundColor(darkGray)
                        }
                        .frame(width: screenWidth)
                        .position(
                            x: screenWidth / 2,
                            y: 172 * scaleY
                        )
                        
                        // 新規グループ作成ボタン - Figma: top: 242px, left: 20px, width: 353px, height: 60px
                        Button(action: {
                            showCreateGroup = true
                        }) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 8 * scaleX)
                                    .fill(mediumBlue)
                                    .frame(width: 353 * scaleX, height: 60 * scaleY)
                                
                                // アイコン - Figma: Group34, left: 35px, top: 252px, width: 41.667px, height: 40px
                                // TSUMO_1を使用（オレンジのキャラクターアイコン）
                                Image("TSUMO_1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 41.667 * scaleX, height: 40 * scaleY)
                                    .position(
                                        x: (35 - 20 + 41.667 / 2) * scaleX, // ボタン内の相対位置
                                        y: (252 - 242) * scaleY // ボタン内の相対位置
                                    )
                                
                                // テキスト - Figma: left: 116px, top: 258px, 18px, Bold, white
                                // ボタンのleft: 20pxからの相対位置なので、116 - 20 = 96px
                                Text("新規グループを作成")
                                    .font(zenMaruGothicFontForGroups(size: 18 * scaleX, weight: .bold))
                                    .foregroundColor(.white)
                                    .position(
                                        x: (116 - 20) * scaleX, // ボタン内の相対位置
                                        y: (258 - 242) * scaleY // ボタン内の相対位置
                                    )
                                
                                // プラス記号 - Figma: left: 347px (中央), top: 259px, 18px, Bold, white
                                // ボタンのleft: 20pxからの相対位置なので、347 - 20 = 327px
                                Text("＋")
                                    .font(zenMaruGothicFontForGroups(size: 18 * scaleX, weight: .bold))
                                    .foregroundColor(.white)
                                    .position(
                                        x: (347 - 20) * scaleX, // ボタン内の相対位置
                                        y: (259 - 242) * scaleY // ボタン内の相対位置
                                    )
                            }
                        }
                        .position(
                            x: (20 + 353 / 2) * scaleX,
                            y: (242 + 60 / 2) * scaleY
                        )
                        
                        // 参加中のグループセクション
                        // タイトル - Figma: top: 350px, left: 19px, 18px, Bold
                        Text("参加中のグループ")
                            .font(zenMaruGothicFontForGroups(size: 18 * scaleX, weight: .bold))
                            .foregroundColor(darkGray)
                            .position(
                                x: 19 * scaleX,
                                y: 350 * scaleY
                            )
                        
                        // グループリスト
                        ForEach(Array(viewModel.groups.enumerated()), id: \.element.id) { index, group in
                            GroupRowView(
                                group: group,
                                scaleX: scaleX,
                                scaleY: scaleY,
                                top: 400 + CGFloat(index) * 76 // 60px高さ + 16px間隔
                            )
                        }
                        
                        // 友だちリストセクション
                        // タイトル - Figma: top: 584px, left: 19px, 18px, Bold
                        Text("友だちリスト")
                            .font(zenMaruGothicFontForGroups(size: 18 * scaleX, weight: .bold))
                            .foregroundColor(darkGray)
                            .position(
                                x: 19 * scaleX,
                                y: 584 * scaleY
                            )
                        
                        // 友だちグリッド - Figma: 3x3グリッド, top: 634pxから開始
                        // カードサイズ: width: 106.627px, height: 133.122px
                        // 間隔: 約23px (142.69 - 19 - 106.627 = 16.063, 266.37 - 142.69 - 106.627 = 17.053)
                        let cardWidth: CGFloat = 106.627
                        let cardHeight: CGFloat = 133.122
                        let cardSpacing: CGFloat = 16.063
                        let gridStartX: CGFloat = 19
                        let gridStartY: CGFloat = 634
                        
                        // サンプルデータ（実際のデータに置き換える必要があります）
                        let friends = Array(repeating: "User Name", count: 9)
                        
                        ForEach(0..<9, id: \.self) { index in
                            let row = index / 3
                            let col = index % 3
                            let cardX = gridStartX + CGFloat(col) * (cardWidth + cardSpacing)
                            let cardY = gridStartY + CGFloat(row) * (cardHeight + 16.32) // 784.44 - 634 = 150.44, 934.88 - 784.44 = 150.44
                            
                            // 友だちカード
                            VStack(spacing: 0) {
                                // アバター - Figma: Ellipse1, width: 53.313px, height: 54.115px
                                Circle()
                                    .fill(primaryOrange)
                                    .frame(width: 53.313 * scaleX, height: 54.115 * scaleY)
                                    .padding(.top, 19.36 * scaleY) // 653.48 - 634 = 19.48
                                
                                // ユーザー名 - Figma: top: 734.11px, 14px, Regular, 中央揃え
                                Text(friends[index])
                                    .font(.system(size: 14 * scaleX, weight: .regular))
                                    .foregroundColor(darkGray)
                                    .padding(.top, 8 * scaleY)
                            }
                            .frame(width: cardWidth * scaleX, height: cardHeight * scaleY)
                            .background(
                                RoundedRectangle(cornerRadius: 8 * scaleX)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                            )
                            .position(
                                x: (cardX + cardWidth / 2) * scaleX,
                                y: (cardY + cardHeight / 2) * scaleY
                            )
                        }
                    }
                    .frame(width: screenWidth, height: 1200 * scaleY) // コンテンツの高さを確保
                }
            }
        }
        .navigationBarHidden(true)
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
    var top: CGFloat = 400
    
    private let darkGray = Color(red: 0.13, green: 0.13, blue: 0.13) // #222
    private let lightGray = Color(red: 0.48, green: 0.48, blue: 0.48) // #7a7a7a
    private let mediumBlue = Color(red: 0.27, green: 0.57, blue: 0.83) // #4591d3
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景カード - Figma: top: 400px, left: 20px, width: 353px, height: 60px
            RoundedRectangle(cornerRadius: 8 * scaleX)
                .fill(Color.white)
                .frame(width: 353 * scaleX, height: 60 * scaleY)
                .shadow(color: .black.opacity(0.25), radius: 2 * scaleX, x: 0, y: 2 * scaleY)
                .position(
                    x: (20 + 353 / 2) * scaleX,
                    y: (top + 60 / 2) * scaleY
                )
            
            // アイコン - Figma: Group49, left: 35px, top: 411px, width: 41.667px, height: 40px
            // カードのleft: 20pxからの相対位置なので、35 - 20 = 15px
            // TSUMO_5_2を使用（青い4枚の花びらのようなアイコン、中心にオレンジのキャラクター）
            Image("TSUMO_5_2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 41.667 * scaleX, height: 40 * scaleY)
                .position(
                    x: (35 - 20 + 41.667 / 2) * scaleX, // カード内の相対位置
                    y: (411 - 400) * scaleY // カード内の相対位置
                )
            
            // グループ名 - Figma: left: 92.67px, top: 417px, 18px, Bold
            // カードのleft: 20pxからの相対位置なので、92.67 - 20 = 72.67px
            Text(group.name)
                .font(zenMaruGothicFontForGroups(size: 18 * scaleX, weight: .bold))
                .foregroundColor(darkGray)
                .position(
                    x: (92.67 - 20) * scaleX, // カード内の相対位置
                    y: (417 - 400) * scaleY // カード内の相対位置
                )
            
            // 招待/管理リンク - Figma: left: 356px (右端), top: 422px, 12px, Bold, #7a7a7a
            // カードのleft: 20px、width: 353pxなので、カード内の相対位置は 356 - 20 = 336px
            // ただし、テキストは右端に配置されるので、カードの右端から少し内側に配置
            Text("招待 / 管理 >")
                .font(zenMaruGothicFontForGroups(size: 12 * scaleX, weight: .bold))
                .foregroundColor(lightGray)
                .position(
                    x: (356 - 20) * scaleX, // カード内の相対位置（右端から少し内側）
                    y: (top + 22) * scaleY // 422 - 400 = 22
                )
        }
    }
}

#Preview {
    GroupsView()
}
