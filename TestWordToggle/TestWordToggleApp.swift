//
//  TestWordToggleApp.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/10.
//

import SwiftUI

@main
struct TestWordToggleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
					SentenceToWordsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
