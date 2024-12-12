//
//  APIService.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import Foundation

final class APIService: ObservableObject {
    @Published var fetchData: IHNFetchAll?
    @Published var modes: [String] = []
    let session: URLSession
    
    static let shared = APIService()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fecthAll(lang: String){
        guard let url = URL(string: "https://erenerhe.fun/api/fetch/all?lang=\(lang)&userToken=1&token=25aeb740-ef45-4790-8f01-e941e008e387") else { print("url error"); return }
        
        session.dataTask(with: url) { data, response, error in
            
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
}
