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
    @State var showingActionSheet: Bool = false
    @State var recordingModal: Bool = false
    @State var uploadModal: Bool = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Upload New Sound"), message: Text(""), buttons: [
            .default(Text("from Recording")) {
                self.recordingModal.toggle()
            },
            .default(Text("from Video")) {
                self.uploadModal.toggle()
            },
            .destructive(Text("Cancel"))
        ])
    }

    var body: some View {
        NavigationView {
            List(/*dataSource.sounds, id: \.self*/) { //sound in
                ForEach(dataSource.sounds, id: \.self) { sound in
                    NavigationLink(destination: DetailView(selectedSound: sound).onDisappear() {
                        // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
                        self.dataSource.updateData()
                    }) {Text(sound)}
                }.onDelete(perform: removeRows)
            }.navigationBarTitle(Text("For Our Friends")).navigationBarItems(
                leading:
                    EditButton(),
                trailing:
                    Button(action: {
                        self.showingActionSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill").resizable()//.imageScale(.large)
                    }
                    .frame(width: 30, height: 30, alignment: .trailing)
                    .actionSheet(isPresented: $showingActionSheet, content: {self.actionSheet}).sheet(isPresented: $recordingModal, content: {
                        RecordingView(dataSource: self.dataSource).onDisappear() {
                            // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
                            self.dataSource.updateData()
                        }
                    })
            ).sheet(isPresented: $uploadModal, content: {
                UploadView().onDisappear() {
                    // DEEPLY INEFFICIENT, BUT IT IS WHAT IT IS
                    self.dataSource.updateData()
                }
            })
        }
    }

    // for now, this only removes the sound from the list, does not delete file
    func removeRows(at offsets: IndexSet) {
        dataSource.sounds.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
