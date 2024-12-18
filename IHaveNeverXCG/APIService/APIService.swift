//
//  APIService.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import Foundation
import SwiftUI

final class APIService: ObservableObject {
    @Published var fetchData: IHNFetchAll?
    @Published var aiIsLoaded: Bool = false
    @Published var isCardsCreated: Bool = false
    @Published var modes: [String] = []
    let session: URLSession
    
    static let shared = APIService()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fecthAll(lang: String){
        guard let url = URL(string: "https://erenerhe.fun/api/fetch/all?lang=\(lang)&userToken=1&token=25aeb740-ef45-4790-8f01-e941e008e387") else { print("url error"); return }
        
        session.dataTask(with: url) { data, _, error in
            
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let data else {
                print("No data")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self.fetchData = try JSONDecoder().decode(IHNFetchAll.self, from: data)
                    
                    self.fetchData?.appDataValue.forEach {
                        self.modes.append($0.appCategoryTitleValue)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func createAI(cardsCount: Int16, gameType: String, tags: String, lang: String, completion: @escaping (Result<AICards, Error>) -> Void){
        let body = "{\n  \"answerLanguage\": \"\(lang)\",\n  \"defaultPrompt\": \"You are a bot for generating cards for the game truth or action. The cards should continue the context of 'I have never', continue this phrase The cards should be interesting, unusual, unique, attract the user, have a different context, depending on the category, be informal and friendly, as in a game atmosphere Answer in \(lang) language. Make \(cardsCount) cards, with the type of game \(gameType), given the \(tags). Write only a card text without 'I have never' or another words. Use only \\n\\n separating between the cards text. I don't need numerating or another separator of text before card starts. Use uppercase letter in the start of the question\", \n  \"arrayDialog\": \n        [\n          {\n            \"role\":\"user\",\n            \"parts\":[\n              {\n                \"text\": \"Generate a cards\"\n              }\n            ]\n          }\n        ]\n}"
        
        let postBody = body.data(using: .utf8)
        
        guard let url = URL(string: "https://garodlono.fun/api/gmnichat") else { print("url error"); return }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postBody
        
        session.dataTask(with: request) { data, _, error in
            if let error {
                print(error.localizedDescription)
                
                withAnimation(.easeInOut(duration: 0.3)){
                    self.aiIsLoaded = false
                }
                return
            }
            
            guard let data = data else {
                print("No data")
                
                withAnimation(.easeInOut(duration: 0.3)){
                    self.aiIsLoaded = false
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    completion(.success(try JSONDecoder().decode(AICards.self, from: data)))
                    
                    withAnimation(.easeInOut(duration: 0.3)){
                        self.aiIsLoaded = false
                        self.isCardsCreated = true
                    }
                } catch {
                    print(error.localizedDescription)
                    
                    withAnimation(.easeInOut(duration: 0.3)){
                        self.aiIsLoaded = false
                    }
                }
            }
        }.resume()
    }
}
