//
//  Controller.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 02.12.2024.
//

import Foundation
import UIKit
import StoreKit

// MARK: All info for MainGameFieldView.swift
final class GameInfo: ObservableObject {
    static let shared = GameInfo()
    
    @Published var gameData: [String] = [] // category collection for listing cards
    @Published var selectedIndex: [Int] = [] // selected category in main page
    @Published var categoryName: [String] = [] // category name on selected language for preview in game field
    @Published var categoryNameEn: [String] = [] // category name on english to select images from assets
    @Published var indexArray: [Int] = [] // need for integrating shuffle with a minimum changes in code
    @Published var isGameStarted: Bool = false // state of game. true - game started and game field open, false - game is ended and game field close
    
    func addData(_ data: [AppCard], name: String, nameEn: String) {
        // function to add all you need data for game
        var index = gameData.count
        data.forEach { item in
            gameData.append(item.appCardTextValue)
            categoryName.append(name)
            categoryNameEn.append(nameEn)
            indexArray.append(index+1)
            index += 1
        }
    }
    
    func removeData(_ data: [AppCard], name: String, nameEn: String) {
        // function to remove data by index from all properties for game
        print(data.count)
        data.forEach { item in
            gameData.removeAll(where: { $0 == item.appCardTextValue })
            categoryName.removeAll(where: { $0 == name })
            categoryName.removeAll(where: { $0 == nameEn })
            indexArray.remove(at: indexArray.count-1)
            print(indexArray.count)
        }
    }
    
    func addAIData(_ data: [String], name: String, nameEn: String) {
        // function to add all you need data for game
        var index = gameData.count
        print(data.count, index)
        data.forEach { item in
            gameData.append(item+".")
            categoryName.append(name)
            categoryNameEn.append(nameEn)
            indexArray.append(index)
            index += 1
            print(index)
        }
    }
    
    func removeAIData(_ data: [String], name: String, nameEn: String) {
        // function to remove data by index from all properties for game
        data.forEach { item in
            gameData.removeAll(where: { $0 == item+"." })
            categoryName.removeAll(where: { $0 == name })
            categoryName.removeAll(where: { $0 == nameEn })
            indexArray.remove(at: indexArray.count-1)
            print(indexArray.count)
        }
    }
}


// MARK: main class for purchase operations
@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    private let productIds = ["ru.yearly.akhmed", "ru.monthly.akhmed"] // all products ids in app
    
    @Published var choice: Int = 0 // choice of product. 0 - yearly, 1 - monthly
    @Published var isPurchasedShow: Bool = false // state to showing purchase page
    
    @Published private(set) var products: [Product] = [] // list of products
    @Published private(set) var purchasedProductIDs = Set<String>() // active purchase list
    
    private var productsLoaded = false // info property about products load state
    private var updates: Task<Void, Never>? = nil // subscribe to transaction updates in app
    
    init() {
        Task {
            await updatePurchasedProducts()
            do {
                try await loadProducts()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.updates = observeTransactionUpdates()
        scheduleSubscriptionCheck()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    var hasUnlockedPro: Bool {
        // automatically update property if subscription is active
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        // load products fron storeKit2
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds).sorted(by: { $0.displayPrice > $1.displayPrice })
        self.productsLoaded = true
        print(products)
    }
    
    func purchase() async throws {
        // function for buying subscription
        let result = try await products[choice].purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        // load info about active subscriptions
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            DispatchQueue.main.async {
                if transaction.revocationDate == nil {
                    self.purchasedProductIDs.insert(transaction.productID)
                } else {
                    self.purchasedProductIDs.remove(transaction.productID)
                }
                self.isPurchasedShow = false
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        // work with transaction data
        Task(priority: .background) {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await handleVerifiedTransaction(transaction)
                    
                case .unverified(let transaction, let verificationError):
                    print("Transaction unverified: \(transaction.id), error: \(verificationError)")
                }
            }
        }
    }

    private func handleVerifiedTransaction(_ transaction: Transaction) async {
        await updatePurchasedProducts()
        await transaction.finish()
        
        print("Transaction \(transaction.id) successfully processed and finished.")
    }
    
    func scheduleSubscriptionCheck() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            Task {
                await self.updatePurchasedProducts()
            }
        }
    }
}

func hasRoundedCorners() -> Bool {
    // check iphone screen type. rounded angle or not
    let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    
    let safeAreaInsets = keyWindow?.safeAreaInsets ?? .zero
    return safeAreaInsets.top > 20 || safeAreaInsets.bottom > 0
}
