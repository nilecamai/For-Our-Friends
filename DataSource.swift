//
//  DataSource.swift
//  For Our Friends
//
//  Created by Nile Camai on 8/1/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import Combine

let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.forourfriends.messages")!
let sharedContainerPath = sharedContainerURL.path

class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    @Published var sounds = [String]()
    
    init() {
        
        let fm = FileManager.default
        
        print(sharedContainerURL)
        
        // makes copies of all Bundle resources in the shared container
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    do {
                        try fm.copyItem(atPath: (path + "/" + item), toPath: (sharedContainerPath + "/" + item))
                    } catch {
                        print("Unable to copy item " + item)
                    }
                }
            }
        }
        
        updateData()
    }
    
    func updateData() {
        sounds.removeAll()
        
        let fm = FileManager.default
        
        // add sounds from Bundle resources
        // ^ EDIT: NO LONGER REFERENCES BUNDLE
        /*
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    sounds.append(item)
                }
            }
        }
         */
        
        // add user-created sounds
        // ^ EDIT: adds ALL sounds
        do {
            let items = try fm.contentsOfDirectory(at: sharedContainerURL, includingPropertiesForKeys: nil)
            for urlItem in items {
                let item = urlItem.lastPathComponent
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    sounds.append(item)
                }
            }
        } catch {
            
        }
        
        didChange.send(())
    }
    
    func addSound(soundFile: SoundFile) {
        // instead of doing the update data thing we will call a method to add the sound
        
    }
    
}

struct SoundFile {
    let name: String
    let path: String
    let userCreated: Bool
    
    // equivalent of toString()
    public var description: String {return name}
}
