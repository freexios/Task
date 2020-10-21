//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Emad Habib on 12/11/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftMessages

class BaseViewModel {
    
    // Dispose Bag
    let disposeBag = DisposeBag()
    let alert = PublishSubject<(String, Theme)>()
    let alertDialog = PublishSubject<(String,String)>()
    
}
