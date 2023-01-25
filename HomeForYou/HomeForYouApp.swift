//
//  HomeForYouApp.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 25/1/23.
//

import SwiftUI

@main
struct HomeForYouApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
