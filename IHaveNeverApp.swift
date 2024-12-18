//
//  IHaveNeverApp.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 26.11.2024.
//

import SwiftUI

@main
struct IHaveNeverApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
