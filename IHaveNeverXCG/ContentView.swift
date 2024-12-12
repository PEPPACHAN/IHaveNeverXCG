//
//  ContentView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var purchaseManager = PurchaseManager.shared
    var body: some View {
        MainPageView()
            .colorScheme(.light)
            .onAppear{
                Task{
                    do{
                        await purchaseManager.updatePurchasedProducts()
                        try await purchaseManager.loadProducts()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
