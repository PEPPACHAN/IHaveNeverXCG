//
//  AIModeView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 28.11.2024.
//

import SwiftUI

struct AIModeView: View {
    @Environment(\.requestReview) var requestReview
    
    @State private var modeName: String = ""
    @State private var selectedMode = ""
    @StateObject private var mode = APIService.shared
    @State private var isSelection: Bool = false
    @State private var isLoading: Bool = false
    @State private var numberOfCards: String = ""
    @State private var tags: String = ""
    @AppStorage("language") private var language = ""
    @AppStorage("isFirstAiGame") private var isFirstAiGame: Bool = true
    
    var body: some View {
        Group {
            VStack{
                Text("aiMode".changeLocale(lang: language))
                    .foregroundStyle(
                        LinearGradient(colors: [
                            Color.init(red: 42/255, green: 15/255, blue: 118/255),
                            Color.init(red: 78/255, green: 28/255, blue: 220/255)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.custom("inter", size: 18.43))
                    .fontWeight(.heavy)
                    .padding()
                
                if !isLoading {
                    TextField("modeName".changeLocale(lang: language), text: $modeName)
                        .font(.custom("inter", size: 16))
                        .fontWeight(.medium)
                        .padding()
                        .background(Color.init(.tertiarySystemFill))
                        .foregroundStyle(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .submitLabel(.done)
                    
                    Button(action:{
                        if !mode.modes.isEmpty {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.isSelection.toggle()
                            }
                        }
                    }){
                        HStack{
                            if !mode.modes.isEmpty {
                                Text(selectedMode == "" ? "selectMode".changeLocale(lang: language): selectedMode)
                                    .font(.custom("inter", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundStyle(
                                        LinearGradient(colors: [
                                            Color.init(red: 42/255, green: 15/255, blue: 118/255),
                                            Color.init(red: 78/255, green: 28/255, blue: 220/255)
                                        ], startPoint: .top, endPoint: .bottom)
                                    )
                            } else {
                                LoadingView(color: Color.init(red: 42/255, green: 15/255, blue: 118/255), size: 30)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.init(red: 197/255, green: 197/255, blue: 197/255))
                                .rotationEffect(.degrees(isSelection ? 90 : 0))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.init(.tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                    
                    if isSelection {
                        modeSelection()
                            .background(Color.init(.tertiarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    if !isSelection {
                        TextField("numberOfCards".changeLocale(lang: language), text: $numberOfCards)
                            .font(.custom("inter", size: 16))
                            .fontWeight(.medium)
                            .keyboardType(.numberPad)
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color.init(.tertiarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                            .submitLabel(.done)
                        
                        ZStack(alignment: .topLeading){
                            if tags.isEmpty{
                                Text("briefTagsForTheGist".changeLocale(lang: language))
                                    .font(.custom("inter", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.black.opacity(0.3))
                                    .padding(.top, 26)
                                    .padding(.horizontal, 35)
                            }
                            TextEditor(text: $tags)
                                .scrollContentBackground(.hidden)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.init(.tertiarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal)
                        }
                    }
                }
                Button(action:{
                    if (modeName != "" && selectedMode != "" && numberOfCards != "" && tags != ""){
                        withAnimation(.easeInOut(duration: 0.3)){
                            self.isLoading.toggle()
                            if isFirstAiGame {
                                requestReview()
                                isFirstAiGame = false
                            }
                        }
                    }
                }){
                    Text("generate".changeLocale(lang: language))
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
        .onAppear{
            GameInfo.shared.selectedIndex = []
            GameInfo.shared.gameData = []
            GameInfo.shared.categoryName = []
            GameInfo.shared.categoryNameEn = []
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .colorScheme(.light)
    }
}

extension AIModeView {
    func modeSelection() -> some View {
        ScrollView{
            VStack(alignment: .leading){
                ForEach(mode.modes, id: \.self){ item in
                    Text(item)
                        .padding()
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            self.selectedMode = item
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.isSelection.toggle()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: isSelection ? .infinity: 0)
    }
}

#Preview {
    MainPageView()
}
