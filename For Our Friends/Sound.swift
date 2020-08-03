//
//  Sound.swift
//  For Our Friends
//
//  Created by Julia on 8/2/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation

class Sound
{
    
    var name: String = ""
    var fileName: String = ""
    var id: Int = 0
    
    init(id:Int, name:String, fileName:String)
    {
        self.id = id
        self.name = name
        self.fileName = fileName
    }
    
}
