//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by Emad Habib on 11/12/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: BaseViewController {

    var viewModel :MoviesListViewModel!
    @IBOutlet weak var tblMovies :UITableView!
    

    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.viewModel.getMovies()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Memory Management Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Setup Methods
extension MoviesListViewController {
    
    private func setup(){
        self.setupUI()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Discover", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        self.tblMovies.tableFooterView = UIView()
        self.tblMovies.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    private func setupBinding(with viewModel: MoviesListViewModel){
        
        self.viewModel.movieTableData.asObservable()
            .bind(to: tblMovies.rx.items(cellIdentifier: String(describing: MovieTableViewCell.self), cellType: MovieTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tblMovies.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.tblMovies.numberOfRows(inSection: indexPath.section) - 3
            })
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
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

