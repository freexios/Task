//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by Emad Habib on 11/12/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import UIKit
import RxSwift
import CoreData
import IQKeyboardManagerSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    private let navigationController:UINavigationController
    private let window: UIWindow
    let dependencies: AppDependency
    
    init(window:UIWindow, navigationController:UINavigationController, managedContext: NSManagedObjectContext) {
        self.window = window
        self.navigationController = navigationController
        self.dependencies = AppDependency(window: self.window, managedContext: managedContext)
    }
    
    override func start() -> Observable<Void> {
        // Show Movie list screen
        return showTabBar()
    }
    
    private func showTabBar() -> Observable<Void> {
        let rootCoordinator = RootCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: rootCoordinator)
    }
    
    deinit {
        plog(AppCoordinator.self)
    }
    
}


class DiscoverCoordinator: BaseCoordinator<Void>{
    typealias Dependencies = HasWindow & HasAPI & HasCoreData

    private let rootNavigationController:UINavigationController
    private let dependencies: Dependencies

    init(navigationController:UINavigationController, dependencies: Dependencies) {
        self.rootNavigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewModel = MoviesListViewModel.init(dependencies: self.dependencies)
        let viewController = UIStoryboard.main.moviesListViewController
        viewController.viewModel = viewModel
        rootNavigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }



    deinit {
        plog(DiscoverCoordinator.self)
    }
}


class SearchCoordinator: BaseCoordinator<Void>{
    typealias Dependencies = HasWindow & HasAPI & HasCoreData

    private let rootNavigationController:UINavigationController
    private let dependencies: Dependencies

    init(navigationController:UINavigationController, dependencies: Dependencies) {
        self.rootNavigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewModel = SearchViewModel.init(dependencies: self.dependencies)
        let viewController = UIStoryboard.main.searchViewController
        viewController.viewModel = viewModel
        rootNavigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }

    

    deinit {
        plog(DiscoverCoordinator.self)
    }
}




class RootCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let dependencies: Dependencies
    private let viewControllers: [UINavigationController]
    
    init(window: UIWindow,dependencies: Dependencies) {
        self.dependencies = dependencies
        self.window = window
        
        let items = HomeBarKind.items
        self.viewControllers = items
            .map({ (items) -> UINavigationController in
                let navigation = UINavigationController()
                navigation.tabBarItem.title = items.title
                navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
                if #available(iOS 13.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithTransparentBackground()
                    appearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
                    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
                    navigation.navigationBar.scrollEdgeAppearance = appearance
                    navigation.navigationBar.prefersLargeTitles = true
                }
                return navigation
            })
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = UIStoryboard.main.rootTabBar
        viewController.tabBar.isTranslucent = false
        viewController.tabBar.tintColor = #colorLiteral(red: 0.7352032065, green: 0, blue: 0.08745174855, alpha: 1)
        viewController.tabBar.backgroundColor = .black
        viewController.viewControllers = viewControllers
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        let coordinates = viewControllers.enumerated()
            .map { (offset, element) -> Observable<Void> in
                guard let items = HomeBarKind(rawValue: offset) else { return Observable.just(() )}
                switch items {
                case.discover :
                    return coordinate(to: DiscoverCoordinator(navigationController: element, dependencies: dependencies))
                case.search :
                    return coordinate(to: SearchCoordinator(navigationController: element, dependencies: dependencies))
                }
            }

        
        Observable.merge(coordinates)
            .subscribe()
            .disposed(by: disposeBag)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
}


enum HomeBarKind: Int {
    case discover
    case search

    var title: String? {
        switch self {
        case .discover:
            return "Discover"
        case .search:
            return "Search"
        }
    }
}


extension RawRepresentable where RawValue == Int {
    
    static var itemCount: Int {
        var index = 0
        while Self(rawValue: index) != nil {
            index += 1
        }
        
        return index
    }
    
    static var items: [Self] {
        var items = [Self]()
        var index = 0
        while let item = Self(rawValue: index) {
            items.append(item)
            index += 1
        }
        
        return items
    }
    
    static var itemsForGuest: [Self] {
        var items = [Self]()
        var index = 1
        while let item = Self(rawValue: index) {
            items.append(item)
            index += 1
        }
        
        return items
    }
    
}
