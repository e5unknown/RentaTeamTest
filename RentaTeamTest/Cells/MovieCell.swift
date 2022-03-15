//
//  MovieCell.swift
//  RentaTeam Test
//
//  Created by Azat Battalov on 14.03.2022.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func initCell(movie: Movie) {
        self.layer.cornerRadius = 15
        
        nameLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage)(\(movie.voteCount))"
        
        let placeholder = UIImage(named: "movie-placeholder")
        let smallImageURL = URL(string: movie.smallImage!)
        if let smallImageURL = smallImageURL{
//            imageView.sd_setImage(with: smallImageURL, placeholderImage: placeholder)
            
            imageView.sd_setImage(with: smallImageURL, placeholderImage: placeholder, options: .waitStoreCache, completed: nil)
        } else{
            imageView.image = nil
        }
    }
    
}
