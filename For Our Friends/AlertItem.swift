//
//  AlertItem.swift
//  For Our Friends
//
//  Created by Nile Camai on 8/2/20.
//  Copyright © 2020 noolnjuul. All rights reserved.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title = Text("")
    var message: Text?
    var dismissButton: Alert.Button?
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button?
}
