//
//  yle_dl_guiApp.swift
//  yle-dl-gui
//
//  Created by Juuso Nurminen on 31.1.2021.
//

import SwiftUI

@main
struct yle_dl_guiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
