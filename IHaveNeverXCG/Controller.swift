//
//  Controller.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 02.12.2024.
//

import Foundation
import UIKit
import StoreKit

final class GameInfo: ObservableObject {
    static let shared = GameInfo()
    
    @Published var gameData: [AppCard] = []
    @Published var selectedIndex: [Int] = []
    @Published var categoryName: [String] = []
    @Published var categoryNameEn: [String] = []
    @Published var isGameStarted: Bool = false
    
    func addData(_ data: [AppCard], name: String, nameEn: String) {
        data.forEach { item in
            gameData.append(item)
            categoryName.append(name)
            categoryNameEn.append(nameEn)
        }
    }
    
    func removeData(_ data: [AppCard], name: String, nameEn: String) {
        data.forEach { item in
            gameData.removeAll(where: { $0.appCardIdValue == item.appCardIdValue })
            categoryName.removeAll(where: { $0 == name })
            categoryName.removeAll(where: { $0 == nameEn })
        }
    }
}


@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    private let productIds = ["ru.yearly.akhmed", "ru.monthly.akhmed"]
    
    @Published var choice: Int = 0
    @Published var isPurchasedShow: Bool = false
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase() async throws {
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
        Task(priority: .background) {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    // Обработайте подтвержденную транзакцию
                    await handleVerifiedTransaction(transaction)
                    
                case .unverified(let transaction, let verificationError):
                    // Вы можете обработать неподтвержденную транзакцию, если необходимо
                    print("Transaction unverified: \(transaction.id), error: \(verificationError)")
                }
            }
        }
    }

    private func handleVerifiedTransaction(_ transaction: Transaction) async {
        do {
            await updatePurchasedProducts()
            await transaction.finish()
            
            print("Transaction \(transaction.id) successfully processed and finished.")
        } catch {
            print("Failed to process transaction \(transaction.id): \(error)")
        }
    }
}

func hasRoundedCorners() -> Bool {
    let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    
    let safeAreaInsets = keyWindow?.safeAreaInsets ?? .zero
    return safeAreaInsets.top > 20 || safeAreaInsets.bottom > 0
}
