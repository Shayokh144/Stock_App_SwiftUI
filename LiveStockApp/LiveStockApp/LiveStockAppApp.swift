//
//  LiveStockAppApp.swift
//  LiveStockApp
//
//  Created by nimble on 25/4/23.
//

import SwiftUI

@main
struct LiveStockAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
