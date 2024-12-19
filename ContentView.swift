//
//  ContentView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import SwiftUI

// MARK: need to change: ContentView, MainPageView, MainPageGMView, BurgerView, AIModeView, FirstFeaturesMainPage, PagesView

struct ContentView: View {
    @StateObject private var purchaseManager = PurchaseManager.shared
    var body: some View {
        MainPageView()
            .colorScheme(.light)
            .environmentObject(purchaseManager)
    }
}

#Preview {
    ContentView()
}
