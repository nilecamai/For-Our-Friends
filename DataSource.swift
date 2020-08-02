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
        let fm = FileManager.default
        
        print(sharedContainerURL)
        
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            
            // for reference purposes
            for item in items {
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    sounds.append(item)
                }
            }
        }
    
        // WILL REMOVE THIS ONCE DONE WITH GROUP CONTAINER CODE
        let path = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let items = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            for urlItem in items {
                let item = urlItem.lastPathComponent
                if item.hasSuffix(".m4a") || item.hasSuffix(".caf") {
                    sounds.append(item)
                }
            }
            // process files
        } catch {
            print("Error while enumerating files \(path.path): \(error.localizedDescription)")
        }
        
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
