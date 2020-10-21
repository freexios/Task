//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Emad Habib on 10/20/20.
//  Copyright © 2020 MAC240. All rights reserved.
//

import UIKit


//MARK: - Movie Tableview Cell
class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvMovie: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    
    func configure(with movie: Movie){
        self.imvMovie.downloadImageWithCaching(with: movie.imageURL,placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
        self.lblMovieTitle.text = movie.title ?? ""
        self.lblMovieDescription.text = movie.overview ?? ""
        self.lblMovieReleaseDate.text = movie.releaseDate ?? ""
    }
    
}
