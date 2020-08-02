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
    @State var showingActionSheet: Bool = false
    @State var recordingModal: Bool = false
    @State var uploadModal: Bool = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Upload New Sound"), message: Text(""), buttons: [
            .default(Text("from Recording")) {
                self.recordingModal.toggle()
            },
            .default(Text("from File")) {
                self.uploadModal.toggle()
            },
            .destructive(Text("Cancel"))
        ])
    }

    var body: some View {
        NavigationView {
            List(dataSource.sounds, id: \.self) { sound in
                NavigationLink(destination: DetailView(selectedSound: sound).onDisappear() {
                    // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
                    self.dataSource.updateData()
                }) {Text(sound)}
            }.navigationBarTitle(Text("For Our Friends")).navigationBarItems(trailing:
                Button(action: {
                    self.showingActionSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill").imageScale(.large)
                }.actionSheet(isPresented: $showingActionSheet, content: {self.actionSheet}).sheet(isPresented: $recordingModal, content: {
                    RecordingView().onDisappear() {
                        // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
                        self.dataSource.updateData()
                    }
                })
//                Button(action: {
//                    self.isModal = true
//                }) {
//                    Image(systemName: "plus.circle.fill").imageScale(.large)
//                }.sheet(isPresented: $isModal, content: {
//                    RecordingView().onDisappear() {
//                        // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
//                        self.dataSource.updateData()
//                    }
//                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

