//
//  ContentView.swift
//  Shared
//
//  Created by Kavisha Sonaal on 13/05/21.
//

import SwiftUI

/*
 Reddit user mentioned that the code works on a restart - https://www.reddit.com/r/SwiftUI/comments/k4k5o5/how_do_i_allow_the_user_to_change_app_icons/gyt0irz/
 It works fine on a Simulator anyways.
 */
struct ContentView: View {
    
    // Refer to details mentioned in AppIconView saying why this is commented.
    // @EnvironmentObject var iconSettings: IconNames
    
    @StateObject private var iconSettings : IconNames = IconNames()
    
    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Appearance")) {
                    NavigationLink(destination: AppIconView()) {
                        Label("Choose another App Icon", systemImage: "square.grid.2x2").foregroundColor(Color.primary)
                    }
                    
                    NavigationLink(destination: AppIconPickerView()) {
                        Label("Choose another App Icon", systemImage: "square.grid.2x2").foregroundColor(Color.primary)
                    }
                    
                    NavigationLink(destination: AppIconStateView()) {
                        Label("Choose another App Icon", systemImage: "square.grid.2x2").foregroundColor(Color.primary)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct AppIconStateView: View  {
    
    @StateObject private var iconSettings : IconNames = IconNames()
    
    @State var chosenIconName : String?
    
    var body: some View {
        
        /// The size of iconNames is 3 due to setting it as [nil] in the AppDelegate. This is done so that the default app icon will also be displayed in this list.
        List(self.iconSettings.iconNames, id: \.self) { item in
            
            HStack {
                HStack(spacing: 15) {
                    // Still blurred image
                    Image(uiImage: UIImage(named: item ?? "AppIcon") ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .cornerRadius(8)
                    
                    Image(uiImage: UIImage(named: item ?? "AppIcon_01") ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        
                        if item == nil {
                            Text("Default")
                            ExternalLinkView(displayName: "@sonaal", clickableLink: "http://twitter.com/sonaal")
                        } else {
                            if let i = item,
                               let fileName = K.fileNameDisplayName[i],
                               let displayName = K.displayNameDisplayLink[i],
                               let clickableLink = K.nameClickableLink[i] {
                                
                                Text(fileName)
                                
                                ExternalLinkView(displayName: displayName, clickableLink: clickableLink)
                                
                            } else {
                                // error on fetching item name. cannot tap
                            }
                        }
                    }
                }
                
                Spacer()
                
                if item == self.chosenIconName {
                    Image(systemName: "checkmark.circle").foregroundColor(Color.accentColor)
                }
            }
            .padding([.top, .bottom], 10)
            .contentShape(Rectangle())
            .onTapGesture {
                if item != self.chosenIconName {
                    UIApplication.shared.setAlternateIconName(item) { error in
                        // TODO: Change this!
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Success! You have changed the app icon to = \(item)")
                            print(self.iconSettings.iconNames)
                            
                            self.chosenIconName = item
                            self.iconSettings.currentIconName = item
                        }
                    }
                }
            }
            // Set the chosenIndex here within the row. IMP: Set on link's onAppear ONLY. Doesnot work outside.
            .onAppear() {
                //self.chosenIndex = self.iconSettings.currentIndex
                //self.chosenIconName = self.iconSettings.currentIconName
                self.chosenIconName = UIApplication.shared.alternateIconName
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Choose Icon")
    }
}

struct K {
    
    // Add more icons here
    static var fileNameDisplayName: Dictionary<String, String> = [
        "MNM_01":"Forks",
        "MNM_02":"Funky Forks",
        "MNM_Sonaal01" : "Pretty Veg"
    ]
    //linkClickableSafariLink
    static var displayNameDisplayLink: Dictionary<String, String> = [
        "Default": "@sonaal",
        "MNM_01":"www.crawfordandjohn.com",
        "MNM_02":"www.crawfordandjohn.com"
    ]
    
    static var nameClickableLink: Dictionary<String, String> = [
        "Default": "http://twitter.com/sonaal",
        "MNM_01":"https://www.crawfordandjohn.com",
        "MNM_02":"https://www.crawfordandjohn.com"
    ]
}
