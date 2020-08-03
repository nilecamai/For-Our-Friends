//
//  RecordingView.swift
//  For Our Friends
//
//  Created by Nile Camai on 7/30/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var dataSource: DataSource
    
    @State var audioPlayer: AVAudioPlayer!
    
    // vars for writing fileName
    @State private var fileName: String = ""
    @State private var recordingExists: Bool = false
    
    // vars for recording button
    @State private var buttonSize: CGFloat = 88
    @State private var buttonCR: CGFloat = 45
    @State private var autoPlay: Bool = true
    
    // vars for recording
    @State var record = false
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var audios: [URL] = []
    
    let url = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String).appendingPathComponent("temp" + audioFormat)!
    
    // alert
    @State var alertItem: AlertItem?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            //Text("Record New Audio").frame(alignment: .top)
            //standard record button
            Button(action: {
                self.buttonSize = self.buttonSize == 88 ? 40 : 88
                self.buttonCR = self.buttonCR == 45 ? 9.6 : 45
                if self.record { // stops recording if already recording
                    self.recorder.stop()
                    self.record.toggle()
                    if !self.recordingExists {self.recordingExists.toggle()}
                    if self.autoPlay {
                        self.playTempAudio()
                    }
                    return
                } else { // starts recording
                    self.recorder.record()
                    self.record.toggle()
                }
            }) {
                ZStack{
                    Circle()
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 5)
                        .frame(width: 100, height: 100)
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: self.buttonSize, height: self.buttonSize)
                        .cornerRadius(self.buttonCR)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6))
                }
            }
            .padding(20)
            .contextMenu {
                Button(action: {
                    self.autoPlay.toggle()
                }) {
                    Text("Turn auto-play " + (self.autoPlay ? "off" : "on"))
                    Image(systemName: (self.autoPlay ? "pause.rectangle" : "play.rectangle")).imageScale(.large)
                }
                Button(action: {
                    
                }) {
                    Text("Save")
                    Image(systemName: "folder.fill.badge.plus").imageScale(.large)
                }.disabled(!self.recordingExists || self.record)
            }
            
            VStack(spacing: 10) {
                Button(action: {
                    self.playTempAudio()
                }) {
                    HStack {
                        Text("Preview")
                        Image(systemName: "play.fill")
                    }
                }
                .disabled(!self.recordingExists || self.record)
                .padding(10)
                Button(action: {
                    
                }) {
                    Text("Save")
                    Image(systemName: "folder.fill.badge.plus")
                }
                .disabled(!self.recordingExists || self.record)
                .padding(10)
            }
        }
        .alert(item: $alertItem) { alertItem in
            guard let primaryButton = alertItem.primaryButton, let secondaryButton = alertItem.secondaryButton else {
                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            return Alert(title: alertItem.title, message: alertItem.message, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .onAppear {
            
            do {
                // start session
                self.session = AVAudioSession.sharedInstance()
                try self.session.setActive(true)
                try self.session.setCategory(
                        AVAudioSession.Category.playAndRecord)
                // define recorder
                let settings =
                    [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                     AVEncoderBitRateKey: 16,
                     AVNumberOfChannelsKey: 2,
                     AVSampleRateKey: 44100.0] as [String : Any]
                self.recorder = try AVAudioRecorder(url: self.url, settings: settings)
                self.recorder?.prepareToRecord()
                self.recordingExists = false
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
        }
    }

    func playTempAudio() {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: self.url.path))
            self.audioPlayer.play()
        } catch {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(dataSource: DataSource())
    }
}
