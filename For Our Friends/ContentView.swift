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

class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    @Published var sounds = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            
            // for reference purposes
            for item in items {
                if item.hasSuffix(".m4a") {
                    sounds.append(item)
                }
            }
        }
        
        didChange.send(())
    }
}

struct ContentView: View {
    @State private var recipes = 0
    //let recipes = ["Recipe 1", "Recipe 2", "Recipe 3"]
    lazy var defaults: Void = UserDefaults.standard.set(recipes, forKey: "recipes")
    
    //let defaults = UserDefaults.init(suiteName: "group.forourfriends.messages")
        //defaults?.set(recipes, forKey: "myRecipes")
        //defaults?.synchronize()
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
                    print("Plus button pressed...")
                }) {
                    Image(systemName: "plus").imageScale(.large)
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
