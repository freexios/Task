//
//  UIStoryboard+Controllers.swift
//  MovieApp
//
//  Created by Emad Habib on 12/11/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

}


extension UIStoryboard {
    
    var moviesListViewController: MoviesListViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: MoviesListViewController.self)) as? MoviesListViewController else {
            fatalError(String(describing: MoviesListViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
        
    var searchViewController: SearchViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? SearchViewController else {
            fatalError(String(describing: SearchViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }

    var rootTabBar: UITabBarController {
        guard let viewController = instantiateViewController(withIdentifier: "RootTabBar") as? UITabBarController else {
            fatalError(String(describing: UITabBarController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }

}
