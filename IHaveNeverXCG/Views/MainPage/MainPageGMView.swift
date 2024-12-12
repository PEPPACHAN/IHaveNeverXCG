//
//  MainPageCards.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 27.11.2024.
//

import SwiftUI

struct MainPageGMView: View {
    @StateObject private var apiData = APIService.shared
    @StateObject private var gameInfo = GameInfo.shared
    @StateObject private var products = PurchaseManager.shared
    @Binding var selectedInfo: Int?
    @AppStorage("language") private var language = ""
    private let screen = UIScreen.main.bounds
    private let freeAccess = ["Manly", "Girls"]
    
    var body: some View {
        ScrollView{
            Group{
                if products.hasUnlockedPro {
                    platesSort(sort: nil)
                } else {
                    HStack{
                        Text("freePacks".changeLocale(lang: language))
                            .foregroundStyle(.white)
                            .font(.custom("inter", size: 13))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14.41)
                            .padding(.vertical, 9.25)
                            .background(
                                LinearGradient(colors: [
                                    Color.init(red: 42/255, green: 15/255, blue: 118/255),
                                    Color.init(red: 78/255, green: 28/255, blue: 220/255)
                                ], startPoint: .top, endPoint: .bottom)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 29))
                        Spacer()
                    }
                    .padding(.bottom, 14)
                    
                    platesSort(sort: true)
                    
                    HStack{
                        Text("premiumPacks".changeLocale(lang: language))
                            .foregroundStyle(.white)
                            .font(.custom("inter", size: 13))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14.41)
                            .padding(.vertical, 9.25)
                            .background(
                                LinearGradient(colors: [
                                    Color.init(red: 42/255, green: 15/255, blue: 118/255),
                                    Color.init(red: 78/255, green: 28/255, blue: 220/255)
                                ], startPoint: .top, endPoint: .bottom)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 29))
                        Spacer()
                        Image("iconLock")
                            .resizable()
                            .frame(width: 28.02, height: 28.02)
                    }
                    .padding(.bottom, 14)
                    
                    platesSort(sort: false)
                }
            }
            .padding(.bottom, !gameInfo.selectedIndex.isEmpty ? screen.height/9 : 0)
        }
        .scrollIndicators(.hidden)
        .padding([.top, .leading, .trailing])
        .padding(.bottom, hasRoundedCorners() ? 16: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

extension MainPageGMView {
    
    func platesSort(sort: Bool?) -> some View {
        ForEach(0..<(apiData.fetchData?.appDataValue.count ?? 1), id: \.self){ index in
            if let item = apiData.fetchData?.appDataValue[index] {
                if sort == nil {
                    platesView(item: item, index: index)
                } else if sort == true {
                    if freeAccess.contains(item.appCategoryTitleEnValue){
                        platesView(item: item, index: index)
                    }
                } else {
                    if !freeAccess.contains(item.appCategoryTitleEnValue){
                        platesView(item: item, index: index)
                    }
                }
            }
        }
    }
    
    func platesView(item: AppData, index: Int) -> some View {
        HStack{
//            Image(item.appCategoryTitleEnValue)
            Image(uiImage: UIImage(named: item.appCategoryTitleEnValue) ?? UIImage(named: "MyPack")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 59.58, height: 56.62)
                .padding(.vertical, 19.66)
                .padding(.leading, 24.36)
                .padding(.trailing, 23.78)
            VStack(alignment: .leading){
                Text(String(describing: item.appCategoryTitleValue))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
                    .font(.custom("inter", size: 19.57))
                    .fontWeight(.heavy)
                
                Text(String(describing: item.appTotalCardsValue) + "cards".localizedPlural(item.appTotalCardsValue, lang: language))
                    .font(.custom("inter", size: 14.87))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white.opacity(0.37))
                
                if item.appCategoryTitleEnValue == "Dirty" {
                    Text("MOST POPULAR")
                        .font(.custom("inter", size: 11.76))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundStyle(Color.white)
                        .font(.custom("inter", size: 12.96))
                        .fontWeight(.heavy)
                        .background(Color.white.opacity(0.09))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 19.31)
                        )
                        .padding(.top, -5)
                        .padding(.bottom, 6)
                }
            }
            Spacer()
            Button(action:{
                withAnimation(.easeInOut(duration: 0.2)) {
                    if products.hasUnlockedPro || freeAccess.contains(item.appCategoryTitleEnValue){
                        selectedInfo = index
                        if !gameInfo.selectedIndex.contains(where: { $0 == index }) {
                            gameInfo.selectedIndex.append(index)
                            gameInfo.addData(item.appCategoryCardsValue, name: item.appCategoryTitleValue, nameEn: item.appCategoryTitleEnValue)
                        }
                    } else {
                        products.isPurchasedShow = true
                    }
                }
            }){
                Circle()
                    .frame(width: 28.37)
                    .foregroundStyle(Color.white.opacity(0.12))
                    .overlay {
                        Text("i")
                            .foregroundStyle(Color.white.opacity(0.36))
                            .font(.system(size: 16.62, weight: .heavy))
                    }
            }
            
            Image(systemName: gameInfo.selectedIndex.contains(where: { $0 == index }) ? "checkmark.circle.fill" : "circle.fill")
                .font(.system(size: 28.37))
                .foregroundStyle( !gameInfo.selectedIndex.contains(where: { $0 == index }) ?
                                  Color.white.opacity(0.12) :
                                    Color.white,
                                  LinearGradient(colors: [
                                    Color.init(red: 23/255, green: 168/255, blue: 143/255),
                                    Color.init(red: 11/255, green: 140/255, blue: 117/255)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 95.93, alignment: .leading)
        .background(
            LinearGradient(colors: [
                Color.init(red: 27/255, green: 28/255, blue: 55/255),
                Color.init(red: 43/255, green: 45/255, blue: 93/255)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 27)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)){
                if products.hasUnlockedPro || freeAccess.contains(item.appCategoryTitleEnValue){
                    if gameInfo.selectedIndex.contains(where: { $0 == index }) {
                        gameInfo.selectedIndex.removeAll(where: { $0 == index })
                        gameInfo.removeData(item.appCategoryCardsValue, name: item.appCategoryTitleValue, nameEn: item.appCategoryTitleEnValue)
                    } else {
                        gameInfo.selectedIndex.append(index)
                        gameInfo.addData(item.appCategoryCardsValue, name: item.appCategoryTitleValue, nameEn: item.appCategoryTitleEnValue)
                    }
                } else {
                    products.isPurchasedShow = true
                }
            }
        }
    }
}

#Preview {
    MainPageView()
}


/*
 
 */
