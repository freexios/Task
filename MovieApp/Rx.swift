//
//  Rx.swift
//  MovieApp
//
//  Created by Emad Habib on 10/21/20.
//  Copyright © 2020 MAC240. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ element: [Element.Element]) {
        accept(value + element)
    }
}
