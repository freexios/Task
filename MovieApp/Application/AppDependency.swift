//
//  AppDependency.swift
//  MovieApp
//
//  Created by Emad Habib on 12/11/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol HasWindow {
    var window: UIWindow { get }
}

protocol HasAPI {
    var api: API { get }
}

protocol HasCoreData {
    var managedObjectContext: NSManagedObjectContext {get}
}

class AppDependency: HasWindow, HasAPI, HasCoreData {
    
    let window: UIWindow
    let api: API
    let managedObjectContext: NSManagedObjectContext
    
    init(window: UIWindow, managedContext: NSManagedObjectContext) {
        self.window = window
        self.api = API.shared
        self.managedObjectContext = managedContext
    }
    
}

