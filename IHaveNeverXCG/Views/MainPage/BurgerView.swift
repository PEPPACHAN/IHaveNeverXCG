//
//  BurgerView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 27.11.2024.
//

import SwiftUI

struct BurgerView: View {
    private let languagesArray = ["en", "de", "ru"]
    
    @State private var retryTimer: Timer? = nil
    
    @AppStorage("language") private var language: String = ""
    @State private var isActive: Bool = false
    @Binding var burgerShowing: Bool
    
    @StateObject private var products = PurchaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 39){
            Image(systemName: "xmark")
                .foregroundStyle(Color.init(red: 222/255, green: 222/255, blue: 222/255))
                .font(.title)
                .bold()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 45)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        burgerShowing.toggle()
                    }
                }
            
            Text("restorePurchases".changeLocale(lang: language))
                .frame(maxWidth: 300, alignment: .leading)
            Text("privacyPolicy".changeLocale(lang: language))
                .frame(maxWidth: 300, alignment: .leading)
            Text("contactUs".changeLocale(lang: language))
                .frame(maxWidth: 300, alignment: .leading)
            HStack{
                Text("language".changeLocale(lang: language))
                    .overlay(alignment: .topTrailing) {
                        Text(
                            language == "de" ? "GE" :
                                language == "en" ? "ENG" :
                                language == "ru" ? "RU": "ENG"
                        )
                        .offset(x: 35, y: -5)
                        .font(.custom("inter", size: 12.96))
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(colors: [
                                Color.init(red: 42/255, green: 15/255, blue: 118/255),
                                Color.init(red: 78/255, green: 28/255, blue: 220/255)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                    }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.init(red: 197/255, green: 197/255, blue: 197/255))
                    .rotationEffect(.degrees(isActive ? -180: 0))
            }
            .background(Color.white)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.isActive.toggle()
                }
            }
            .padding(.trailing, 45)
            
            if isActive {
                moreLanguages()
            }
            
            Spacer()
            
            HStack {
                Image("crown")
                Text(products.hasUnlockedPro ? "premiumActivated".changeLocale(lang: language) : "noPremiumAccess".changeLocale(lang: language)) // MARK: Translate to german
                    .foregroundStyle(
                        LinearGradient(colors: [
                            Color.init(red: 42/255, green: 15/255, blue: 118/255),
                            Color.init(red: 78/255, green: 28/255, blue: 220/255)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.custom("inter", size: 18.45))
                    .fontWeight(.medium)
            }
            .onTapGesture {
                if !products.hasUnlockedPro {
                    products.isPurchasedShow = true
                }
                burgerShowing = false
            }
        }
        .font(.custom("inter", size: 21.36))
        .fontWeight(.bold)
        .foregroundStyle(Color.black)
        .padding([.top, .horizontal], 36)
    }
}

extension BurgerView {
    func moreLanguages() -> some View {
        VStack(spacing: 27){
            ForEach(languagesArray, id: \.self) { item in
                HStack{
                    Text(
                        item == "de" ? "German" :
                            item == "en" ? "English" :
                            item == "ru" ? "Russian": "ENG"
                    )
                    .font(.custom("inter", size: 17.7))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)){
                            language = item
                            self.isActive.toggle()
                            loadDataWithRetry(lang: language)
                            GameInfo.shared.categoryName.removeAll()
                            GameInfo.shared.categoryNameEn.removeAll()
                            GameInfo.shared.gameData.removeAll()
                            GameInfo.shared.selectedIndex.removeAll()
                            burgerShowing.toggle()
                        }
                    }
                    Spacer()
                    Image(systemName: item == language ? "checkmark.circle.fill" : "circle.fill")
                        .font(.system(size: 21.82))
                        .foregroundStyle( item != language ?
                                          Color.init(red: 242/255, green: 242/255, blue: 242/255) :
                                            Color.white,
                                          LinearGradient(colors: [
                                            Color.init(red: 42/255, green: 15/255, blue: 118/255),
                                            Color.init(red: 78/255, green: 28/255, blue: 220/255)
                                          ], startPoint: .top, endPoint: .bottom)
                        )
                        .padding(.trailing, 45)
                }
            }
        }
    }
}

extension BurgerView {
    private func loadDataWithRetry(lang: String) {
        APIService.shared.fetchData = nil
        APIService.shared.modes.removeAll()
        if APIService.shared.modes.isEmpty {
            APIService.shared.fecthAll(lang: lang)
            retryTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                if APIService.shared.modes.isEmpty {
                    APIService.shared.fecthAll(lang: lang)
                } else {
                    retryTimer?.invalidate()
                }
            }
        }
    }
}

#Preview {
    MainPageView()
}
