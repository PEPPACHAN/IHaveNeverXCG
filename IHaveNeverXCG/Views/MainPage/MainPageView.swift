//
//  MainPageView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 27.11.2024.
//

import SwiftUI
import CoreData

struct MainPageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CustomCards.id, ascending: false)],
        animation: .default)
    private var cardsData: FetchedResults<CustomCards>
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    // main page. its just connect all views
    @AppStorage("wasShown") private var wasShown: Bool = false
    @AppStorage("language") private var language = ""
    @State private var retryTimer: Timer? = nil
    
    @StateObject private var apiData = APIService.shared
    @StateObject private var gameInfo = GameInfo.shared
    @State private var burgerShowing: Bool = false
    @State private var selectedTab: Bool = false
    @State private var selectedInfo: Int?
    @State private var hasNewItem: Bool = false
    
    private let screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("App Title")
                        .font(.custom("inter", size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    VStack(spacing: 2){
                        ForEach(0..<2){ _ in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 27.72, height: 4.5)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            burgerShowing.toggle()
                        }
                    }
                }
                .padding(25)
                .foregroundStyle(Color.white)
                
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 334.74, height: 56)
                    .foregroundStyle(Color.white)
                    .padding(.bottom)
                    .overlay {
                        ZStack{
                            RoundedRectangle(cornerRadius: 24.99)
                                .frame(width: 162.26, height: 49.98)
                                .foregroundStyle(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                                .padding(.bottom)
                                .offset(x: selectedTab ? 82.26: -82.26) // +-
                            HStack{
                                Text("gameModes".changeLocale(lang: language))
                                    .font(.custom("inter", size: 16))
                                    .fontWeight(.medium)
                                    .frame(width: 105)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                    .foregroundStyle(!selectedTab ? Color.white : Color.init(red: 42/255, green: 15/255, blue: 118/255))
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            hasNewItem = false
                                            selectedTab = false
                                        }
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        Text(hasNewItem ? "1": "")
                                            .font(.custom("inter", size: 11.18))
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: 6, maxHeight: 14)
                                            .padding(.vertical, 2.5)
                                            .padding(.horizontal, 6.5)
                                            .background ( hasNewItem ?
                                                          AnyView(LinearGradient(colors: [
                                                              Color(red: 23/255, green: 168/255, blue: 143/255),
                                                              Color(red: 11/255, green: 140/255, blue: 117/255)
                                                          ], startPoint: .topLeading, endPoint: .bottomTrailing)) :
                                                          AnyView(Color.clear)
                                            ) // it calls compiler error because gradient and color is different type
                                            .clipShape(Circle())
                                            .offset(x: 1, y: -5)
                                    }
                                Spacer()
                                Text("aiMode".changeLocale(lang: language))
                                    .font(.custom("inter", size: 16))
                                    .fontWeight(.medium)
                                    .frame(width: 64)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(selectedTab ? Color.white : Color.init(red: 42/255, green: 15/255, blue: 118/255))
                                    .padding(.bottom)
                                    .padding(.trailing, 22)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedTab = true
                                        }
                                    }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                if !apiData.modes.isEmpty {
                    if !selectedTab {
                        MainPageGMView(selectedInfo: $selectedInfo)
                            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 38))
                    } else {
                        AIModeView(hasNewItem: $hasNewItem)
                            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 38))
                    }
                } else {
                    LoadingView(color: Color.init(red: 42/255, green: 15/255, blue: 118/255), size: 70)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 38))
                }
            }
            .ignoresSafeArea()
            .padding(.top, 1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [
                    Color.init(red: 42/255, green: 15/255, blue: 118/255),
                    Color.init(red: 78/255, green: 28/255, blue: 220/255),
                ], startPoint: .top, endPoint: .bottom)
            )
            
            if !gameInfo.selectedIndex.isEmpty {
                Button(action:{
                    gameInfo.isGameStarted.toggle()
                }){
                    RoundedRectangle(cornerRadius: 27)
                        .frame(height: 69.71)
                        .padding(.horizontal)
                        .foregroundStyle(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                        .overlay {
                            VStack{
                                Text("play".changeLocale(lang: language))
                                    .foregroundStyle(Color.white)
                                    .font(.custom("inter", size: 17.48))
                                    .fontWeight(.bold)
                                Text(String(describing: gameInfo.selectedIndex.count) + "board".localizedPlural(gameInfo.selectedIndex.count, lang: language) + String(describing: gameInfo.gameData.count) + "cards".localizedPlural(gameInfo.gameData.count, lang: language))
                                    .font(.custom("inter", size: 14.87))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white.opacity(0.37))
                            }
                        }
                }
                .offset(y: UIScreen.main.bounds.height / 2.5)
            }
            
            if gameInfo.isGameStarted {
                MainGameFieldView(selectedTab: $selectedTab, hasNewItem: $hasNewItem)
            }
            
            if purchaseManager.isPurchasedShow { // MARK: switch to appHud
                FourthPageView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(colors: [Color.init(red: 42/255, green: 15/255, blue: 118/255), Color.init(red: 78/255, green: 28/255, blue: 220/255), Color.init(red: 42/255, green: 15/255, blue: 118/255)], startPoint: .top, endPoint: .bottom)
                    )
            }
            
            if !wasShown {
                FirstFeaturesPageView()
                    .transition(.opacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if selectedInfo != nil {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(Color.black.opacity(0.4))
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        selectedInfo = nil
                    }
                showInfoView(index: selectedInfo ?? 0)
                    .frame(height: 413.04)
                    .padding(.horizontal, 5)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 27))
            }
             
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(Color.black.opacity(0.4))
                .ignoresSafeArea()
                .offset(x: burgerShowing ? -100: 600)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        burgerShowing.toggle()
                    }
                }
            BurgerView(burgerShowing: $burgerShowing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .offset(x: burgerShowing ? 50 : 700)
        }
        .onAppear{
            selectedTab = false
            gameInfo.gameData = []
            gameInfo.selectedIndex = []
            gameInfo.isGameStarted = false
            gameInfo.categoryName = []
            gameInfo.categoryNameEn = []
            gameInfo.indexArray = []
            if language == "" {
                language = Locale.current.language.languageCode?.identifier ?? "en"
            }
            loadDataWithRetry(lang: language)
        }
    }
}

extension MainPageView {
    private func showInfoView(index: Int) -> some View {
        var dataTitleEn: String?
        var dataInfo: String?
        let indexOffset = apiData.fetchData?.appDataValue.count ?? 0
        
        if index-indexOffset < 0 {
            dataTitleEn = apiData.fetchData?.appDataValue[index].appCategoryTitleEnValue
            dataInfo = apiData.fetchData?.appDataValue[index].appCategoryInfoValue
        } else {
            dataTitleEn = cardsData[index-(apiData.fetchData?.appDataValue.count ?? 0)].collectionName
            dataInfo = cardsData[index-(apiData.fetchData?.appDataValue.count ?? 0)].tags
        }
        return VStack(spacing: 49.4) {
            HStack(alignment: .top){
                Circle()
                    .frame(width: 46.66)
                    .foregroundStyle(Color.init(red: 79/255, green: 79/255, blue: 79/255, opacity: 0.08))
                    .overlay {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(Color.init(red: 171/255, green: 171/255, blue: 171/255))
                    }
                    .onTapGesture {
                        selectedInfo = nil
                    }
                
                Spacer()
                
                Image(dataTitleEn ?? "")
                    .resizable()
                    .frame(width: 141.36, height: 134.43)
                    .aspectRatio(contentMode: .fill)
                
                Spacer()
                
                Circle()
                    .frame(width: 46.66)
                    .foregroundStyle(
                        LinearGradient(colors: [
                            Color.init(red: 42/255, green: 15/255, blue: 118/255),
                            Color.init(red: 78/255, green: 28/255, blue: 220/255)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay {
                        Image(systemName: "play.fill")
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        selectedInfo = nil
                        gameInfo.isGameStarted.toggle()
                    }
            }
            
            Text(dataInfo ?? "")
                .font(.custom("inter", size: 20))
                .fontWeight(.medium)
                .foregroundStyle(.black)
            
            Button(action:{
                // MARK: ask about the button
                selectedInfo = nil
            }){
                Text("understood".changeLocale(lang: language))
                    .foregroundStyle(.white)
                    .font(.custom("inter", size: 16.33))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 65.13)
                    .background(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                    .clipShape(RoundedRectangle(cornerRadius: 23))
                    .padding()
            }
        }
        .padding()
    }
    
    private func loadDataWithRetry(lang: String) {
        if APIService.shared.fetchData == nil {
            APIService.shared.fecthAll(lang: lang)
            retryTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                if APIService.shared.fetchData == nil {
                    APIService.shared.fecthAll(lang: lang)
                } else {
                    retryTimer?.invalidate()
                }
            }
        }
    }
    
    struct RoundedCornersShape: Shape {
        var corners: UIRectCorner
        var radius: CGFloat

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}

#Preview {
    MainPageView()
}
