//
//  ContentView.swift
//  For Our Friends
//
//  Created by Nile Camai on 7/28/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import AVFoundation
import Combine
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var dataSource = DataSource()
    @State var isModal: Bool = false

    var body: some View {
        
        NavigationView {
            List(dataSource.sounds, id: \.self) { sound in
                NavigationLink(destination: DetailView(selectedSound: sound)) {Text(sound)}
            }.navigationBarTitle(Text("For Our Friends"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.isModal = true
                }) {
                    Image(systemName: "plus.circle.fill").imageScale(.large)
                }.sheet(isPresented: $isModal, content: {
                    AddView()
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func playAudioFromDocuments(selectedSound: String) {
    var audioPlayer: AVAudioPlayer!
    do {
        if let fileURL = Bundle.main.path(forResource:  selectedSound, ofType: "") {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            audioPlayer?.play()
        } else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(selectedSound) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    audioPlayer = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: filePath))
                    audioPlayer?.play()
                    print("success")
                } else {
                    print("FILE NOT AVAILABLE")
                    print(filePath)
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
        }
    } catch let error {
        print("Can't play the audio file failed with an error \(error.localizedDescription)")
    }
}
