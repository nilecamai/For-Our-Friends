//
//  Sound.swift
//  For Our Friends
//
//  Created by Julia on 8/2/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation

class Sound : Identifiable {
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        // equate based on UUID
        return lhs.id == rhs.id
    }
    
    var fileName: String = ""
    var description: String = ""
    var id = UUID()
    
    init(fileName: String, description: String) {
        self.fileName = fileName
        self.description = description
    }
    
    // if no description is given
    init(fileName: String) {
        self.fileName = fileName
        self.description = fileName
    }
    
    // i dont actually know why we need this
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
