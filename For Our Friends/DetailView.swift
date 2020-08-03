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
    
    var sound: Sound
    
    var body: some View {
        // content of DetailView
        VStack(spacing: 25) {
            Button(action: {
                do {
                    let path = NSURL(fileURLWithPath: sharedContainerURL.absoluteString).appendingPathComponent(self.sound.fileName)!.path
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    self.audioPlayer.play()
                    print(path)
                    return
                } catch let error {
                    print("Can't play the audio file failed with an error \(error.localizedDescription)")
                }
            }) {
                Image(systemName: "play")
            }.navigationBarTitle(sound.description)
            Text(sound.description) // TODO: change to TextField
        }
    }
}

