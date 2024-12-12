//
//  PagesViews.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import SwiftUI
import StoreKit

struct FirstPageView: View {
    @AppStorage("language") private var language = ""
    private let screen = UIScreen.main.bounds
    var body: some View {
        ZStack{
            VStack{
                Image("firstPageFirst")
                Image("firstPageOther")
            }
            .offset(y: -50)
            .mask({
                Rectangle() //  rgba(45, 16, 125, 1)
                    .offset(y: -250)
                    .blur(radius: 50)
                    .frame(width: 1000, height: 700)
            })
            VStack(spacing: hasRoundedCorners() ? 20: 7){
                Text("1MQuestions".changeLocale(lang: language))
                    .multilineTextAlignment(.center)
                    .font(.custom("inter", size: 26.94))
                    .fontWeight(.bold)
                    .frame(maxWidth: screen.width/1.72, maxHeight: screen.height/12.9)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(Color.white)
                Text("haveFun".changeLocale(lang: language))
                    .multilineTextAlignment(.center)
                    .font(.custom("inter", size: 20.5))
                    .frame(maxWidth: screen.width/1.57, maxHeight: screen.height/17.04)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(Color.white)
            }
            .offset(y: hasRoundedCorners() ? 210: 190)
        }
    }
}

struct SecondPageView: View {
    @AppStorage("language") private var language = ""
    private let screen = UIScreen.main.bounds
    var body: some View {
        ZStack{
            Image("handKeeper")
                .offset(y: -100)
            VStack(spacing: hasRoundedCorners() ? 20: 7){
                Text("sexDirtyQuestions".changeLocale(lang: language))
                    .multilineTextAlignment(.center)
                    .font(.custom("inter", size: 26.94))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                Text("lotsOfDirty".changeLocale(lang: language))
                    .multilineTextAlignment(.center)
                    .font(.custom("inter", size: 20.5))
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(Color.white)
            }
            .offset(y: hasRoundedCorners() ? 210: 180)
        }
    }
}

struct ThirdPageView: View {
    @AppStorage("language") private var language = ""
    var body: some View {
        VStack(spacing: 20){
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 37))
                .offset(y: -25)
            
            VStack(spacing: -18){
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .font(.custom("inter", size: 25))
                HStack(spacing: 40){
                    ForEach(0..<2){ _ in
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                            .font(.custom("inter", size: 25))
                    }
                }
                HStack(spacing: 100){
                    ForEach(0..<2){ _ in
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                            .font(.custom("inter", size: 25))
                    }
                }
            }
            .offset(y: -5)
            
            Text("thankYou".changeLocale(lang: language))
                .multilineTextAlignment(.center)
                .font(.custom("inter", size: 26.94))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Text("showYourLove".changeLocale(lang: language))
                .multilineTextAlignment(.center)
                .font(.custom("inter", size: 20.5))
                .foregroundStyle(Color.white)
        }
    }
}

struct FourthPageView: View {
    @StateObject private var products = PurchaseManager.shared
    @AppStorage("language") private var language = ""
    
    var body: some View {
        VStack(spacing: 30){
            if products.isPurchasedShow{
                HStack{
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)){
                                products.isPurchasedShow = false
                            }
                        }
                }
                .offset(y: hasRoundedCorners() ? -50: 20)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 50)
                .padding(.top, 40)
            }
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 78.5, height: 78.5)
                .clipShape(RoundedRectangle(cornerRadius: 18.4))
                .offset(y: hasRoundedCorners() ? -25: 0)
            
            Text("getFullAccess".changeLocale(lang: language))
                .font(.custom("inter", size: 26.94))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .offset(y: hasRoundedCorners() ? -20: -10)
            
            VStack(alignment: .leading, spacing: 20){
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.white)
                    HStack(spacing: 5){
                        Text("AICards".changeLocale(lang: language))
                            .frame(width: 80, height: 25)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .font(.custom("inter", size: 16.6))
                            .foregroundStyle(Color.black)
                        Text("create".changeLocale(lang: language))
                            .font(.custom("inter", size: 16.6))
                            .foregroundStyle(Color.white)
                    }
                }
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.white)
                    Text("3-DayFreeTrial".changeLocale(lang: language))
                        .font(.custom("inter", size: 16.6))
                        .foregroundStyle(Color.white)
                }
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.white)
                    Text("dirtySexCards".changeLocale(lang: language))
                        .font(.custom("inter", size: 16.6))
                        .foregroundStyle(Color.white)
                }
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.white)
                    Text("newContent".changeLocale(lang: language))
                        .font(.custom("inter", size: 16.6))
                        .foregroundStyle(Color.white)
                }
            }
            .offset(y: hasRoundedCorners() ? 0: -10)
            
            VStack(spacing: 10) {
                HStack(spacing: 15){
                    VStack(alignment: .leading){
                        Text("yearly".changeLocale(lang: language))
                            .foregroundStyle(Color.white)
                            .font(.custom("inter", size: 16))
                            .fontWeight(.bold)
                        HStack(spacing: 5){
                            Text("3-DayFreeTrial".changeLocale(lang: language))
                                .foregroundStyle(Color.white)
                                .font(.custom("inter", size: 16))
                                .fontWeight(.medium)
                            Text("$90.00year".changeLocale(lang: language))
                                .foregroundStyle(Color.white.opacity(0.5))
                                .font(.custom("inter", size: 11.96))
                        }
                    }
                    .padding(.leading, 25)
                    Spacer()
                    Image(systemName: products.choice == 0 ? "checkmark.circle.fill": "circle")
                        .font(.custom("inter", size: 22))
                        .foregroundStyle(Color.white)
                        .padding(.trailing, 25)
                }
                .frame(width: 370, height: 60)
                .background(Color.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .overlay {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white, lineWidth: products.choice == 0 ? 1: 0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        products.choice = 0
                    }
                }
                HStack(spacing: 15){
                    VStack(alignment: .leading){
                        Text("monthly".changeLocale(lang: language))
                            .foregroundStyle(Color.white)
                            .font(.custom("inter", size: 16))
                            .fontWeight(.bold)
                        HStack(spacing: 5){
                            Text("/month".changeLocale(lang: language))
                                .foregroundStyle(Color.white)
                                .font(.custom("inter", size: 16))
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.horizontal, 25)
                    Spacer()
                    Image(systemName: products.choice == 1 ? "checkmark.circle.fill": "circle")
                        .font(.custom("inter", size: 22))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 25)
                }
                .frame(width: 370, height: 60)
                .background(Color.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .overlay {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white, lineWidth: products.choice == 1 ? 1: 0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        products.choice = 1
                    }
                }
            }
            .padding(products.isPurchasedShow ? 20: 0)
            .offset(y: hasRoundedCorners() ? 0: -10)
            
            if products.isPurchasedShow{
                VStack{
                    Button (action: {
                        Task{
                            do{
                                try await products.purchase()
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                    }){
                        Text("continue".changeLocale(lang: language))
                            .font(.custom("inter", size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: UIScreen.main.bounds.width - 100)
                            .frame(height: 60)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                    }
                    .offset(y: -3)
                    
                    HStack {
                        Text("Terms of Use")
                        Spacer()
                        Button {
                            Task {
                                do{
                                    try await AppStore.sync()
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
                    .foregroundStyle(Color.gray.opacity(0.4))
                    .font(.custom("inter", size: 14.09))
                    .fontWeight(.medium)
                    .offset(y: 18)
                    .padding(.horizontal, 50)
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    FirstFeaturesPageView()
}
