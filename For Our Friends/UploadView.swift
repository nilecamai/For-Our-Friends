//
//  UploadView.swift
//  For Our Friends
//
//  Created by Nile Camai on 8/1/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import SwiftUI

struct UploadView: View {
    
    @State private var showingImagePicker = true
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                self.showingImagePicker.toggle()
            }) {
                Text("Upload From Video")
            }
            
        }.onAppear {
            
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }.alert(item: $alertItem) { alertItem in
            guard let primaryButton = alertItem.primaryButton, let secondaryButton = alertItem.secondaryButton else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}
