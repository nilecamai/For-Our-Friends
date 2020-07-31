//
//  DetailView.swift
//  For Our Friends
//
//  Created by Nile Camai on 7/30/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

struct DetailView: View {
    
    @State var audioPlayer: AVAudioPlayer!
    
    var selectedSound: String
    
    var body: some View {
        // content of DetailView
        VStack(spacing: 25) {
            Button(action: {
                do {
                    if let fileURL = Bundle.main.path(forResource:  self.selectedSound, ofType: "") {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                        self.audioPlayer.play()
                    } else {
                        print("No file with specified name exists")
                    }
                } catch let error {
                    print("Can't play the audio file failed with an error \(error.localizedDescription)")
                }
                print("Edit button was tapped")
            }) {
                Image(systemName: "play")
            }.navigationBarTitle(selectedSound)
            Text(selectedSound) // TODO: change to TextField
        }
    }
}

