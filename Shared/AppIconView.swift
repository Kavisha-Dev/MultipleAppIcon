//
//  AppIconView.swift
//  MultipleAppIcon (iOS)
//
//  Created by Kavisha Sonaal on 21/05/21.
//

import SwiftUI

/*
 Whenver the user changes the icon and minimes the screen to see the change in the app icon, and then when he open the app again, the MultipleAppIconApp.swift gets called, & due to environmentObject, the getAlternateIcons gets called. Due to this, sometimes the order of elements in the IconNames array gets altered. i.e sometimes it is [nil, MNM_01, MNM_02] and sometimes gets changed to [nil, MNM_02, MNM_01]
 Due to this selected icon postion in the UI keeps shifting. Also if the index is used to keep track of the selected element then due to the changed array elements, the item at the previuosly chosen index will change and hence different item, hence different app icon will be shown as selected.
 In order to fix this issue, used the app icon name for checking and used Icon Name as a StateObject since its not used anywhere else.
 */
struct AppIconView: View  {
    
    @EnvironmentObject var iconSettings: IconNames
    @State var chosenIndex : Int = -1
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        
        /// The size of iconNames is 3 due to setting it as [nil] in the AppDelegate. This is done so that the default app icon will also be displayed in this list.
        List(self.iconSettings.iconNames, id: \.self) { item in
            
            HStack {
                HStack(spacing: 10) {
                    Image(uiImage: UIImage(named: item ?? "AppIcon") ?? UIImage())
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
                
                if let index = self.iconSettings.iconNames.firstIndex(of: item), self.chosenIndex == index {
                    HStack {
                        Image(systemName: "checkmark.circle").foregroundColor(Color.accentColor)
                    }
                    
                }
            }
            .padding([.top, .bottom], 10)
            .contentShape(Rectangle())
            .onTapGesture {
                
                let selectedIndex = self.iconSettings.iconNames.firstIndex(of: item) ?? 0
                
                if selectedIndex != self.iconSettings.currentIndex {
                    UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[selectedIndex]) { error in
                        // TODO: Change this!
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print(self.iconSettings.iconNames)
                            
                            self.chosenIndex = selectedIndex
                            self.iconSettings.currentIndex = selectedIndex
                        }
                    }
                }
            }
            // Set the chosenIndex here within the row. IMP: Set on link's onAppear ONLY. Doesnot work outside.
            .onAppear() {
                self.chosenIndex = self.iconSettings.currentIndex
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Choose Icon")
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}
