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

class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    @Published var sounds = [String]()
    
    init() {
        updateData()
    }
    
    func updateData() {
        sounds.removeAll()
        
        let fm = FileManager.default
        
        // add sounds from Bundle resources
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    sounds.append(item)
                }
            }
        }
        
        // add user-created sounds
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
    
}
