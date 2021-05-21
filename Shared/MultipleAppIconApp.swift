//
//  MultipleAppIconApp.swift
//  Shared
//
//  Created by Kavisha Sonaal on 13/05/21.
//

import SwiftUI

@main
struct MultipleAppIconApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environmentObject(IconNames())
        }
    }
}


// MARK: - ALTERNATE ICONS

class IconNames: ObservableObject {
    
    /// Setting nil at the first index to support the primary icon to be displayed. i.e when the iconname is nil, the primary icon will be set.
    /// the first element of the iconNames array is set as nil as an indicator of the primary app icon.
    var iconNames: [String?] = [nil]
    @Published var currentIndex = 0
    
    @Published var currentIconName: String?
    
    init() {
        getAlternateIconNames()
        
        self.currentIconName = UIApplication.shared.alternateIconName
        
        /*if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }*/
    }
    
    func getAlternateIconNames() {
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
            for (_, value) in alternateIcons {
                guard let iconList = value as? Dictionary<String,Any> else { return }
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else { return }
                guard let icon = iconFiles.first else { return }
                
                iconNames.append(icon)
            }
            print("iconNames \(iconNames)")
            print("\n")
        }
    }
}
