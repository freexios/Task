//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Emad Habib on 10/20/20.
//  Copyright © 2020 MAC240. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreData

final class SearchViewModel: BaseViewModel {
    
    // Dependencies
    private let dependencies: Dependencies
    var managedObjectContext: NSManagedObjectContext!
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //API Result
    var getMoviesData: Observable<APIResult<GetMovieResponse>> {
        return _getMoviesData.asObservable().observeOn(MainScheduler.instance)
    }
    private let _getMoviesData = ReplaySubject<APIResult<GetMovieResponse>>.create(bufferSize: 1)
    
    //Data
    var movieTableData: Observable<[Movie]>
    var movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    
    var recentResults: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    //Paging Metadata
    var nextPage: Int? = 1
    var isFromCoredata: Bool = false
    
    //Method
    var latestSearchText = PublishSubject<String>()
    var callNextPage = PublishSubject<Void>()
    let selectedMovie = PublishSubject<Movie?>()
    
    // private attr
    private var searchText =  ""
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.movieTableData = movies.asObservable()
        self.managedObjectContext = dependencies.managedObjectContext
        super.init()
        
        
        self.latestSearchText.asObservable().subscribe(onNext: { [weak self] text in
            guard let `self` = self , text.count > 0 else { return }
            self.searchText = text
        }).disposed(by: disposeBag)
        
        self.callNextPage.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            // Check internet availability, call next page API if internet available
            if NetworkReachabilityManager()!.isReachable == true {
                if self.nextPage != nil {
                    self.getMovies(searchText:self.searchText,nextPage: self.nextPage!)
                }
            } else {
                // Fetch movie data from local cache, as internet is not available
                self.alertDialog.onNext((NSLocalizedString("Network error", comment: ""), "internet is not available"))
            }
        }).disposed(by: disposeBag)
        
        // Load Recent Search Results
        getRecentSearchFromCoreData()
    }
    
}

//MARK:- Core Data
extension SearchViewModel {
    
    func getRecentSearchFromCoreData() {
        managedObjectContext.rx.entities(RecentCoredataModel.self, sortDescriptors: []).asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let `self` = self else {return}
                
                // Check local cache record count and binded array count same, no need to execute further code
                if self.recentResults.value.count == data.count {
                    return
                }
                
                var conData = [String]()
                for n in data {
                    conData.append(n.query)
                }
                self.recentResults.acceptAppending(conData)
            }).disposed(by: disposeBag)
    }
    
}

//MARK:- API Call
extension SearchViewModel {
    
    func getMovies(searchText:String,nextPage: Int = 1) {
        let parameter = [
            Params.apiKey.rawValue : Environment.MOVIEDB_APIKEY(),
            Params.page.rawValue   : nextPage,
            Params.query.rawValue : searchText
        ] as [String : Any]
        
        dependencies.api.getSearchData(param: parameter)
            .trackActivity(nextPage == 1 ? isLoading : ActivityIndicator())
            .observeOn(MainScheduler.asyncInstance)
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success(value: let v):
                        self._getMoviesData.on(event)
                        if let data = v.results , data.count > 0 {
                            _ = try? self.managedObjectContext.rx.update(RecentCoredataModel(query: searchText))
                        }else {
                            self.alertDialog.onNext(("Warning", "No results found"))
                        }
                    case .failure(let error):
                        // Fetch data from local cache when internet is not available
                        if error.code == InternetConnectionErrorCode.offline.rawValue {
                            //                            self.getMoviesFromCoreData()
                            self.alertDialog.onNext((NSLocalizedString("Network error", comment: ""), error.message))
                        } else {
                            self.alertDialog.onNext(("Error", error.message))
                        }
                    }
                    
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
}
