//
//  ExternalLinkView.swift
//  MultipleAppIcon (iOS)
//
//  Created by Kavisha Sonaal on 20/05/21.
//

import SwiftUI

struct ExternalLinkView: View  {
    
    //@Binding var displayName: String
    
    //@Binding var clickableLink: String
    
    var displayName: String = ""
    
    var clickableLink: String = ""
    
    @State var tapped : Bool = false
    
    @State var timer: Timer?
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    
    
    var body: some View {
        
        /*Button(action: {
            print("TAPPED")
        }, label: {
            Text(displayName)
        })
        .padding()*/
        
        Text(displayName).onTapGesture {

            self.hapticImpact.impactOccurred()
            
            self.tapped = true

            self.timer?.invalidate()

            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (t) in
                self.tapped.toggle()
            }

            withAnimation {
                if let url = URL(string: clickableLink) {
                    UIApplication.shared.open(url)
                }
            }
        }
        //.padding([.top, .bottom], 5)
        .animation(.easeIn)
        .foregroundColor(tapped ? Color.gray : Color.blue)
        .background(tapped ? Color(UIColor.tertiarySystemBackground) : nil)
        //.border(tapped ? Color(UIColor.secondarySystemBackground) : Color.primary)
        .font(.callout)
        .cornerRadius(8)
    }
    
}

struct ExternalLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalLinkView()
    }
}
