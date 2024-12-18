//
//  AIModeView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 28.11.2024.
//

import SwiftUI
import CoreData

struct AIModeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CustomCards.id, ascending: true)],
        animation: .default)
    private var cardsData: FetchedResults<CustomCards>
    
    @Environment(\.requestReview) var requestReview
    
    @FocusState private var isNameField: Bool
    @FocusState private var isNumberOfCard: Bool
    @FocusState private var isTags: Bool // textfields is focused state to show and hide keyboard
    
    @State private var showRating: Bool = false
    @State private var modeName: String = ""
    @State private var selectedMode = ""
    @StateObject private var mode = APIService.shared
    @StateObject private var purchase = PurchaseManager.shared
    @StateObject private var gameInfo = GameInfo.shared
    @State private var isSelection: Bool = false
    @State private var numberOfCards: String = ""
    @State private var tags: String = ""
    @State private var aiCards: [String] = []
    @AppStorage("language") private var language = ""
    @AppStorage("isFirstAiGame") private var isFirstAiGame: Bool = true // state from userdefaults to show rating page if its first ai usage
    
    var body: some View {
        ZStack{
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
                        .padding(hasRoundedCorners() ? 16: 5)
                    
                    if !mode.isCardsCreated {
                        if !mode.aiIsLoaded {
                            TextField("modeName".changeLocale(lang: language), text: $modeName)
                                .font(.custom("inter", size: 16))
                                .fontWeight(.medium)
                                .focused($isNameField)
                                .padding()
                                .background(Color.init(.tertiarySystemFill))
                                .foregroundStyle(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal)
                            
                            Button(action:{
                                if !mode.modes.isEmpty {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.isSelection.toggle()
                                    }
                                    isNameField = false
                                    isNumberOfCard = false
                                    isTags = false
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
                                    .focused($isNumberOfCard)
                                    .keyboardType(.numberPad)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color.init(.tertiarySystemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .padding(.horizontal)
                                
                                ZStack(alignment: .topLeading){
                                    if tags.isEmpty{
                                        Text("briefTagsForTheGist".changeLocale(lang: language)) // tags field
                                            .font(.custom("inter", size: 16))
                                            .focused($isTags)
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
                            Button(action:{
                                if purchase.hasUnlockedPro {
                                    if (modeName != "" && selectedMode != "" && numberOfCards != "" && tags != ""){
                                        withAnimation(.easeInOut(duration: 0.3)){
                                            mode.aiIsLoaded = true
                                            saveCustomCards(name: modeName, numberOfCards: numberOfCards, selectedMode: selectedMode, tags: tags, lang: language)
                                        }
                                        if isFirstAiGame {
                                            showRating = true
                                        }
                                    }
                                } else {
                                    isNameField = false
                                    isNumberOfCard = false
                                    isTags = false
                                    purchase.isPurchasedShow = true
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
                            .padding()
                        } else {
                            Text("wait".changeLocale(lang: language))
                                .font(.custom("inter", size: 22.75))
                                .fontWeight(.medium)
                                .frame(maxHeight: .infinity)
                            RoundedRectangle(cornerRadius: 23)
                                .frame(maxWidth: .infinity, maxHeight: 65.13)
                                .foregroundStyle(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                                .padding()
                                .padding(.bottom)
                                .padding(.horizontal)
                                .overlay {
                                    LoadingView(color: .white, size: 19.22)
                                        .padding(.bottom)
                                }
                        }
                    } else {
                        // ai pack created
                        VStack{
                            VStack{
                                Image("MyPack")
                                    .resizable()
                                    .frame(width: 103.28, height: 103.28)
                                Text(modeName.capitalizeFirstLetter())
                                    .foregroundStyle(.white)
                                    .font(.custom("inter", size: 21.57))
                                    .fontWeight(.heavy)
                                Text(String(describing: aiCards.count) + "cards".localizedPlural(aiCards, lang: language))
                                    .foregroundStyle(.white.opacity(0.37))
                                    .font(.custom("inter", size: 16.39))
                                    .fontWeight(.medium)
                            }
                            .background(
                                LinearGradient(colors: [
                                    Color.init(red: 27/255, green: 28/255, blue: 66/255),
                                    Color.init(red: 43/255, green: 45/255, blue: 93/255)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24.58))
                            
                            Button(action:{
                                withAnimation(.easeInOut(duration: 0.3)){
                                    gameInfo.addAIData(aiCards, name: modeName, nameEn: modeName+".")
                                    gameInfo.isGameStarted = true
                                }
                            }){
                                Text("play".changeLocale(lang: language))
                                    .foregroundStyle(.white)
                                    .font(.custom("inter", size: 16.33))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, maxHeight: 65.13)
                                    .background(Color.init(red: 56/255, green: 25/255, blue: 145/255))
                                    .clipShape(RoundedRectangle(cornerRadius: 23))
                                    .padding()
                            }
                            .padding()
                        }
                    }
                }
                .onAppear{
                    GameInfo.shared.selectedIndex = []
                    GameInfo.shared.gameData = []
                    GameInfo.shared.categoryName = []
                    GameInfo.shared.categoryNameEn = []
                    APIService.shared.aiIsLoaded = false
                    APIService.shared.isCardsCreated = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .colorScheme(.light)
                .onTapGesture {
                    isNameField = false
                    isNumberOfCard = false
                    isTags = false
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSelection = false
                    }
                }
                .onChange(of: isNameField) { newValue in
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSelection = false
                        }
                        isNameField = newValue
                    } else {
                        isNameField = newValue
                    }
                }
                .onChange(of: isNumberOfCard) { newValue in
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSelection = false
                        }
                        isNumberOfCard = newValue
                    } else {
                        isNumberOfCard = newValue
                    }
                }
                .onChange(of: isTags) { newValue in
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSelection = false
                        }
                        isTags = newValue
                    } else {
                        isTags = newValue
                    }
                }
                
                if showRating {
                    requestRating()
                }
            }
        }
        .onAppear {
            Task{
                await purchase.updatePurchasedProducts()
            }
        }
    }
}

extension AIModeView {
    func saveCustomCards(name: String, numberOfCards: String, selectedMode: String, tags: String, lang: String){
        mode.createAI(cardsCount: Int16(numberOfCards) ?? 0, gameType: selectedMode, tags: tags, lang: lang) { result in
            switch result {
            case .success(let success):
                guard let data = success.candidates.first?.content.parts.first?.text.dropLast(2).components(separatedBy: "\n\n") else { return }
                print("saving: " + String(describing: data.prefix(Int(numberOfCards) ?? 0)))
                viewContext.performAndWait {
                    do {
                        let newItems = CustomCards(context: viewContext)
                        newItems.id = UUID()
                        newItems.cardsCount = Int16(data.prefix(Int(numberOfCards) ?? 0).count)
                        newItems.collectionName = modeName.capitalizeFirstLetter()
                        newItems.cardsArray = try JSONSerialization.data(withJSONObject: Array(data.prefix(Int(numberOfCards) ?? 0)), options: [])
                        do{
                            try viewContext.save()
                        }catch{
                            print(error.localizedDescription)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                self.aiCards = Array(data.prefix(Int(numberOfCards) ?? 0))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func modeSelection() -> some View {
        // show list of category after button pressed
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
    
    
    func requestRating() -> some View {
        // show rating page
        ZStack{
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(Color.black.opacity(0.4))
                .ignoresSafeArea(.all)
                .onTapGesture {
                    showRating = false
                    isFirstAiGame = false
                }
            RequestReviewView(showRating: $showRating, isRatingPresent: $isFirstAiGame)
        }
    }
}

#Preview {
    MainPageView()
}
