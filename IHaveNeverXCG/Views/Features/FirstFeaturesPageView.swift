//
//  FirstFeaturesPageView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import SwiftUI
import StoreKit

struct FirstFeaturesPageView: View {
    // first signed pages about application
    @AppStorage("wasShown") var wasShown: Bool = false // state from userdefaults. if false it will show but after xmark click never show again
    @AppStorage("language") private var language = "" // current language from bundle
    private let screen = UIScreen.main.bounds
    
    @State private var currentPage = 0
    private let colors = [
        LinearGradient(colors: [Color.init(red: 42/255, green: 15/255, blue: 118/255), Color.init(red: 78/255, green: 28/255, blue: 220/255), Color.init(red: 42/255, green: 15/255, blue: 118/255)], startPoint: .top, endPoint: .bottom),
        LinearGradient(colors: [Color.init(red: 155/255, green: 20/255, blue: 148/255), Color.init(red: 190/255, green: 18/255, blue: 101/255), Color.init(red: 155/255, green: 20/255, blue: 148/255)], startPoint: .top, endPoint: .bottom),
        LinearGradient(colors: [Color.init(red: 15/255, green: 118/255, blue: 89/255), Color.init(red: 28/255, green: 220/255, blue: 201/255), Color.init(red: 15/255, green: 118/255, blue: 89/255)], startPoint: .top, endPoint: .bottom),
        LinearGradient(colors: [Color.init(red: 42/255, green: 15/255, blue: 118/255), Color.init(red: 78/255, green: 28/255, blue: 220/255), Color.init(red: 42/255, green: 15/255, blue: 118/255)], startPoint: .top, endPoint: .bottom)
    ]
    
    @EnvironmentObject var purchaseManager: PurchaseManager // purchase manager for last page
    
    var body: some View {
        VStack{
            HStack {
                // indicators of current page in top
                ForEach(0..<4) { index in
                    Rectangle()
                        .foregroundStyle(index == currentPage ? .white : .gray.opacity(0.5))
                        .frame(width: 60, height: 4)
                        .clipShape(.capsule)
                        .animation(.easeInOut, value: currentPage)
                }
                Image(systemName: "xmark") // xmark to close page
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .offset(x: 20)
                    .opacity(currentPage == 3 ? 1: 0)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)){
                            wasShown.toggle()
                        }
                    }
            }
            .padding(.horizontal, 50)
            .padding(.top, 40)
            
            TabView(selection: $currentPage) {
                FirstPageView()
                    .tag(0)
                SecondPageView()
                    .tag(1)
                ThirdPageView()
                    .tag(2)
                FourthPageView() // last page and main page to buy subscriptions in application
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Button (action: {
                if currentPage < 3{
                    withAnimation(.easeInOut(duration: 0.5)){
                        currentPage+=1 // switch pages with animation
                    }
                } else {
                    Task{
                        do{
                            try await purchaseManager.purchase() // continue button change themself work logic from listing to purchase
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            }){
                Text("continue".changeLocale(lang: language))
                    .font(.custom("inter", size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, maxHeight: screen.height/14.2)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .offset(y: hasRoundedCorners() ? -28: 0)
            
            HStack {
                // i have no data for this buttons
                Text("Terms of Use")
                Spacer()
                Button {
                    Task {
                        do{
                            try await AppStore.sync() // restore purchase request to apple servers
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Restore")
                }
                Spacer()
                Text("Privacy Policy")
            }
            .disabled(currentPage != 3)
            .foregroundStyle(currentPage == 3 ? Color.gray.opacity(0.4): Color.clear)
            .font(.custom("inter", size: 14.09))
            .fontWeight(.medium)
            .padding(.horizontal, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colors[currentPage].ignoresSafeArea())
    }
}

#Preview {
    FirstFeaturesPageView()
}
