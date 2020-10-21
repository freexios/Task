//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Emad Habib on 10/20/20.
//  Copyright © 2020 MAC240. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class SearchViewController: BaseViewController{


    @IBOutlet weak var tblMovies :UITableView!
    @IBOutlet weak var searchBar :UISearchBar!
    var dropButton = DropDown()
    var viewModel :SearchViewModel!
    
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
        
    // MARK: - Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: - Setup Methods
extension SearchViewController {
    
    private func setupDropDown(){
        searchBar.delegate = self
        searchBar.placeholder = "Type something here to search"
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .darkGray
        dropButton.anchorView = searchBar
        dropButton.bottomOffset = CGPoint(x: 0, y:searchBar.frame.size.height)
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom
        dropButton.selectionAction = { [unowned self] (index: Int, item: String) in
            self.getNewData(name: item)
            self.searchBar.text = item
        }
    }
    
    private func setup(){
        self.setupUI()
        self.setupDropDown()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Search", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        self.tblMovies.tableFooterView = UIView()
        self.tblMovies.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        self.tblMovies.register(UINib(nibName: "RecentTCell", bundle: nil), forCellReuseIdentifier: "RecentTCell")
    }
    
    @objc func dismissKey(){
        self.searchBar.resignFirstResponder()
    }
    
    private func setupBinding(with viewModel: SearchViewModel){
        
        view.rx.tapGesture()
            .when(.recognized)
                .subscribe({ _ in
                    self.view.endEditing(true)
                })
                .disposed(by: disposeBag)

        self.searchBar.rx.tapGesture().when(.recognized)
            .subscribe({ _ in
                if let searchT = self.searchBar.text , searchT.count == 0{
                    self.dropButton.show()
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.movieTableData.asObservable()
            .bind(to: tblMovies.rx.items(cellIdentifier: String(describing: MovieTableViewCell.self), cellType: MovieTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        self.viewModel.recentResults.asObservable().subscribe { [weak self] (dataX) in
            guard let self = self , let data = dataX.element else {return}
            guard data.count > 0 else {return}
            self.dropButton.dataSource = data
        }.disposed(by: disposeBag)
        
        tblMovies.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.tblMovies.numberOfRows(inSection: indexPath.section) - 3
            })
            .throttle(.seconds(60), scheduler: MainScheduler.instance)
            .map({ event -> Void in
                return Void()
            })
            .bind(to: viewModel.callNextPage)
            .disposed(by: disposeBag)
                
        viewModel.isLoading
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (isLoading) in
                guard let `self` = self else { return }
                self.hideActivityIndicator()
                if isLoading {
                    self.showActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.alertDialog.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (title, message) in
                guard let `self` = self else {return}
                self.showAlertDialogue(title: title, message: message)
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , text.count > 0 else {
            self.viewModel.latestSearchText.onNext("")
            return
        }
        getNewData(name: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.clear()
        self.viewModel.latestSearchText.onNext("")
        self.searchBar.text = ""
    }
    
    private func getNewData(name:String) {
        self.clear()
        self.viewModel.latestSearchText.onNext(name)
        self.viewModel.getMovies(searchText: name)
    }
    
    private func clear(){
        self.dismissKey()
        self.dropButton.hide()
        self.viewModel.movieTableData = .empty()
        self.viewModel.movies.accept([])
        self.viewModel.nextPage = 1
    }

}
