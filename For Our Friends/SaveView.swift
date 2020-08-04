//
//  SaveView.swift
//  For Our Friends
//
//  Created by Nile Camai on 8/3/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import SwiftUI

// purpose: when either recordingview or uploadview load a sound to temp, copy temp to container to effectively save it
struct SaveView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // @State vars go here
    @State private var fileName: String = ""
    @State private var description: String = ""
    
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(alignment: .firstTextBaseline) {
                Text("Save as file:")
                    .frame(width: 110)
                TextField("File name", text: $fileName)
                .padding(10)
                .frame(width: 200)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack(alignment: .firstTextBaseline) {
                VStack() {
                    Text("Description:")
                    Text("(optional)").font(.footnote)
                }.frame(width: 110)
                TextField("Description", text: $description)
                .padding(10)
                .frame(width: 200)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                if self.fileName.isEmpty { // prevents recording if no name given
                    self.alertItem = AlertItem(title: Text("Error"), message: Text("Please submit a file name for this sound"))
                    return
                }
                let fm = FileManager.default
                let url = sharedContainerURL.appendingPathComponent(self.fileName + ".caf")
                do {
                    try fm.copyItem(at: tempDocURL, to: url)
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }) {
                Text("Submit")
            }.padding(5)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel").foregroundColor(Color.red)
            }.padding(5)
        }.alert(item: $alertItem) { alertItem in
            guard let primaryButton = alertItem.primaryButton, let secondaryButton = alertItem.secondaryButton else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
    
}

struct SaveView_Previews: PreviewProvider {
    static var previews: some View {
        SaveView()
    }
}
