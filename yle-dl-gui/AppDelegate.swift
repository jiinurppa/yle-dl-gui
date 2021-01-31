//
//  AppDelegate.swift
//  yle-dl-gui
//
//  Created by Juuso Nurminen on 31.1.2021.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
