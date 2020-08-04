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


let tempDocURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String).appendingPathComponent("temp" + audioFormat)!

let audioFormat = ".caf"

class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    @Published var sounds = [Sound]()
    
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
    }
    
    // only call when something absolutely fatal happened to data and you must reset
    func updateData() {
        sounds.removeAll()
        
        let fm = FileManager.default
        
        do {
            let items = try fm.contentsOfDirectory(at: sharedContainerURL, includingPropertiesForKeys: nil)
            for urlItem in items {
                let fileName = urlItem.lastPathComponent
                if fileName.hasSuffix(".m4a") || fileName.hasSuffix(".caf") {
                    // does not know custom name given so it will appear as fileName
                    let sound = Sound(fileName: fileName)
                    sounds.append(sound)
                }
            }
        } catch {
            
        }
        didChange.send(())
    }
    
    func addSound(sound: Sound) {
        // instead of doing the update data thing we will call a method to add the sound
        sounds.append(sound)
    }
    
}
