//
//  Environment.swift
//  MovieApp
//
//  Created by Emad Habib on 12/11/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import Foundation

enum Server {
    case developement
    case staging
    case production
}

class Environment {
    //Add Target conditions here and set defualt server here based on Target.
//    #if BASEPROJECT_PRODUCTION
//        static let server:Server    =   .production
//    #elseif BASEPROJECT_STAGING
//        static let server:Server    =   .staging
//    #else
//        static let server:Server    =   .developement
//    #endif
    
    static let server:Server    =   .developement
    
    // To print the log set true.
    static let debug:Bool       =   true
    
    class func APIBasePath() -> String {
        switch self.server {
            case .developement:
                return "https://api.themoviedb.org/"
            case .staging:
                return "https://api.themoviedb.org/"
            case .production:
                return "https://api.themoviedb.org/"
        }
    }
    
    class func APIVersionPath() -> String {
        switch self.server {
        case .developement:
            return "3/"
        case .staging:
            return "3/"
        case .production:
            return "3/"
        }
    }
    
    class func MOVIEDB_APIKEY() -> String {
        switch self.server {
        case .developement:
            return "b7c7f70743b34c7697a502bee82d7594"
        case .staging:
            return "b7c7f70743b34c7697a502bee82d7594"
        case .production:
            return "14bc774791d9d20b3a138bb6e26e2579"
        }
    }
    
}


