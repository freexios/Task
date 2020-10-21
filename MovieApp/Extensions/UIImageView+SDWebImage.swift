//
//  UIImageView+SDWebImage.swift
//  MovieApp
//
//  Created by Emad Habib on 11/13/20.
//  Copyright © 2018 Emad Habib. All rights reserved.
//

import Foundation
import Kingfisher


extension UIImageView {
    
    public func downloadImageWithCaching(with url: String,placeholderImage: UIImage? = nil){
        if url == ""{
            self.image = placeholderImage
            return
        }
        guard let imageURL = URL.init(string: url) else{
            self.image = placeholderImage
            return
        }
        self.kf.setImage(with: imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.1))], progressBlock: nil, completionHandler: { (image, error, cacheType, _url) in
            //self.image = image
        })
    }
    
}
