//
//  RecentSearchModel.swift
//  MovieApp
//
//  Created by Emad Habib on 10/20/20.
//  Copyright © 2020 MAC240. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


struct RecentCoredataModel {
    var query:String
    
    init(query:String) {
        self.query = query
    }
}

func == (lhs: RecentCoredataModel, rhs: RecentCoredataModel) -> Bool {
    return lhs.query == rhs.query
}

extension RecentCoredataModel : Equatable { }

extension RecentCoredataModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(query)" }
}

extension RecentCoredataModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "RecentSearchList"
    }
    
    static var primaryAttributeName: String {
        return "query"
    }
    
    init(entity: T) {
        query = entity.value(forKey: "query") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(query, forKey: "query")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
