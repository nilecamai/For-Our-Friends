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
                        
                        let path = sharedContainerURL.absoluteString
                        let url = NSURL(fileURLWithPath: path)
                        if let pathComponent = url.appendingPathComponent(self.selectedSound) {
                            let filePath = pathComponent.path
                            let fileManager = FileManager.default
                            if fileManager.fileExists(atPath: filePath) {
                                self.audioPlayer = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: filePath))
                                self.audioPlayer.play()
                            } else {
                                print("FILE NOT AVAILABLE")
                            }
                        } else {
                            print("FILE PATH NOT AVAILABLE")
                        }
                        
//                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//                        let url = NSURL(fileURLWithPath: path)
//                        if let pathComponent = url.appendingPathComponent(self.selectedSound) {
//                            let filePath = pathComponent.path
//                            let fileManager = FileManager.default
//                            if fileManager.fileExists(atPath: filePath) {
//                                self.audioPlayer = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: filePath))
//                                self.audioPlayer.play()
//                            } else {
//                                print("FILE NOT AVAILABLE")
//                            }
//                        } else {
//                            print("FILE PATH NOT AVAILABLE")
//                        }
                    }
                } catch let error {
                    print("Can't play the audio file failed with an error \(error.localizedDescription)")
                }
            }) {
                Image(systemName: "play")
            }.navigationBarTitle(selectedSound)
            Text(selectedSound) // TODO: change to TextField
        }
    }
}

