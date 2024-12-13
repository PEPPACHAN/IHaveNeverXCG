//
//  APIService.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import Foundation

final class APIService: ObservableObject {
    @Published var fetchCustomData: FetchAllCustom?
    @Published var fetchData: IHNFetchAll?
    @Published var customModes: [String] = []
    @Published var aiIsLoaded: Bool = false
    @Published var modes: [String] = []
    @Published var newCustomCard: [String] = []
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
    
    func fetchAllCustom(lang: String, userToken: String) {
        guard let url = URL(string: "https://erenerhe.fun/api/fetch/custom?lang=\(lang)&userToken=\(userToken)&token=25aeb740-ef45-4790-8f01-e941e008e387") else { print("url error"); return }
        
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
                    self.fetchCustomData = try JSONDecoder().decode(FetchAllCustom.self, from: data)
                    
                    self.fetchCustomData?.appDataValue.forEach {
                        self.customModes.append($0.appCategoryTitleValue)
                    }
                    self.aiIsLoaded = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func createCustom(cardText: String, cardsCount: Int, lang: String, userToken: String){
        for _ in 0..<cardsCount {
            guard let url = URL(string: "https://erenerhe.fun/api/card/create?userToken=\(userToken)&cardText=\(cardText)&lang=\(lang)&token=25aeb740-ef45-4790-8f01-e941e008e387") else { print("url error"); return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            session.dataTask(with: request) { data, _, error in
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if data == nil {
                    print("No data")
                    return
                }
            }.resume()
        }
        
        self.fetchAllCustom(lang: lang, userToken: userToken)
    }
}
