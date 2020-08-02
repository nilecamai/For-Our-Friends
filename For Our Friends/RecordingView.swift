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

struct RecordingView: View {
    
    @State var audioPlayer: AVAudioPlayer!
    
    // vars for writing fileName
    @State private var fileName: String = ""
    
    // vars for recording
    @State var record = false
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var audios: [URL] = []
    
    // alert
    @State var alertItem: AlertItem?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Record New Audio").frame(alignment: .top)
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
                        // PLEASE work omg
                        
//                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName + ".caf")
                        
                        let url = sharedContainerURL.appendingPathComponent(self.fileName + ".caf")
                        
                        let settings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                        AVEncoderBitRateKey: 16,
                        AVNumberOfChannelsKey: 2,
                        AVSampleRateKey: 44100.0] as [String : Any]
                        
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
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 6)
                            .frame(width :85, height: 85)
                    }
                }
            }
            
            //THIS BUTTON DOESN'T DO ANYTHING YET
            Button(action: {
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                if let pathComponent = url.appendingPathComponent(self.fileName + ".caf") {
                    let filePath = pathComponent.path
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filePath) {
                        print("FILE AVAILABLE")
                        print(fileManager.contents(atPath: filePath))
                    } else {
                        print("FILE NOT AVAILABLE")
                        print(filePath)
                    }
                } else {
                    print("FILE PATH NOT AVAILABLE")
                }
//                do {
//                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName + ".m4a").absoluteString))
//                    self.audioPlayer.play()
//                } catch let error as NSError {
//                    print("you should not be seeing this")
//                    print("audioPlayer error: \(error.localizedDescription)")
//                }
            }) {
                HStack {
                    Text("Play")
                    Image(systemName: "play.fill").imageScale(.large)
                }
            }.disabled(false)
            Spacer().frame(height: 20)
            VStack(){
                TextField("File name", text: $fileName)
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    print("Upload button was tapped")
                }) {
                    Text("Upload")
                }
                .frame(width: 150, height: 50)
            }
        }
        .frame(height: 400)
        .alert(item: $alertItem) { alertItem in
            guard let primaryButton = alertItem.primaryButton, let secondaryButton = alertItem.secondaryButton else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .onAppear {
            let fileMgr = FileManager.default

            let dirPaths = fileMgr.urls(for: .documentDirectory,
                            in: .userDomainMask)

            let soundFileURL = dirPaths[0].appendingPathComponent(self.fileName + ".caf")

            let recordSettings = [
                AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey : 12000,
                AVNumberOfChannelsKey : 1,
                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ]

            do {
                self.session = AVAudioSession.sharedInstance()
                try self.session.setActive(true)
                try self.session.setCategory(
                        AVAudioSession.Category.playAndRecord)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }

            do {
                try self.recorder = AVAudioRecorder(url: soundFileURL,
                    settings: recordSettings as [String : AnyObject])
                self.recorder?.prepareToRecord()
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
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

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
