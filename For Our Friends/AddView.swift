//
//  AddView.swift
//  For Our Friends
//
//  Created by Nile Camai on 7/30/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

struct AddView: View {
    
    // vars for writing fileName
    @State private var fileName: String = ""
    
    // vars for recording
    @State var record = false
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var audios: [URL] = []
    
    // alert
    @State var alertItem: AlertItem?
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text("Record New Audio")
            //standard record button
            Button(action: {
                do {
                    if self.fileName.isEmpty { // prevents recording if no name given
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Please submit a file name for this recording"))
                        return
                    } else if self.record { // stops recording if already recording
                        self.recorder.stop()
                        self.record.toggle()
                        
                        // updating data for every rcd... demonstration video
                        // self.getAudios()
                        return
                    } else { // starts recording
                        //let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        // same file name...
                        // so were updating based on audio count...
                        
                        let url = getDocumentsDirectory().appendingPathComponent(self.fileName + ".m4a")
                        
                        // testing file name REMOVE THIS LATER
                        print(url)
                        return
                        
                        let settings = [
                            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey : 12000,
                            AVNumberOfChannelsKey : 1,
                            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                        ]
                        
                        self.recorder = try AVAudioRecorder(url: url, settings: settings)
                        // TODO: write AVAudiorecorder line for custom filename
                        self.recorder.record()
                        self.record.toggle()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }) {
                ZStack{
                    Circle()
                        .fill(Color.red)
                        .frame(width: 70, height: 70)
                    Circle()
                        .opacity(0)
                        .frame(width :85, height: 85)
                    if self.record {
                        Circle()
                            .stroke(Color.white, lineWidth: 6)
                            .frame(width :85, height: 85)
                    }
                }
            }
            HStack(alignment: .center) {
                // idea: have a textfield and button combo together, and have a text and button combo together; button toggles "editing" filename and textfield is when active, text when submitted
                // you know the rest haah ahh
                TextField("File name", text: $fileName)
                    .frame(width: 150, height: 50)
                Button(action: {
                    print("Upload button was tapped")
                }) {
                    Text("Upload")
                }
                .frame(width: 150, height: 50)
            }
        }.alert(item: $alertItem) { alertItem in
            guard let primaryButton = alertItem.primaryButton, let secondaryButton = alertItem.secondaryButton else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .onAppear {
        
            do {
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                self.session.requestRecordPermission{ (status) in
                    if !status {
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Please enable access to the microphone"))
                    } else {
                        self.getAudios()
                    }
                }
            } catch {
        
            }
        }
    }
    
    func getAudios() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // fetch all data from document directory...
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            // updated means remove all old data..
            self.audios.removeAll()
            for i in result {
                self.audios.append(i)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title = Text("")
    var message: Text?
    var dismissButton: Alert.Button?
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button?
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
