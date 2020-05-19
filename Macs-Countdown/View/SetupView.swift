//
//  SetupView.swift
//  Macs Ager
//
//  Created by Loyi Hsu on 2020/5/19.
//  Copyright © 2020 Loyiworks. All rights reserved.
//

import SwiftUI

struct SetupView: View {
    @State var deviceName: String = "Mac"
    @State var time = Date()
    
    var body: some View {
        VStack{
            Text("Please enter the following information.")
            VStack {
                HStack {
                    Text("Device Name:")
                    TextField("Enter your device name here.", text: $deviceName)
                }
                DatePicker(selection: $time, label: { Text("Start Counting From...") })
            }
            .padding(.horizontal)
            
            Button(action: {
                UserDefaults.standard.set(self.time, forKey: "userSetDate")
                UserDefaults.standard.set(self.deviceName, forKey: "userSetName")
                #warning("TODO: Need to dismiss this window.")
                #warning("TODO: Need to refresh the app state.")
            }) {
                Text("OK")
            }
            .padding(.top, 10.0)
            
            #if DEBUG
            Button(action: {
                UserDefaults.standard.set(nil, forKey: "userSetDate")
                UserDefaults.standard.set(nil, forKey: "userSetName")
            }) {
                Text("Reset")
            }
            #endif
            
        }
        .frame(width: 360, height: 160, alignment: .center)
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
