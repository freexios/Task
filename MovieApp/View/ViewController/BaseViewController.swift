//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Emad Habib on 12/11/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseViewController: UIViewController, AlerteableViewController, ActivityIndicatorViewable {

    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

