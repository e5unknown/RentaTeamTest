//
//  MovieController.swift
//  RentaTeamTest
//
//  Created by Azat Battalov on 14.03.2022.
//

import UIKit

class MovieController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var downloadTimestampLabel: UILabel!
    
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadTimestampLabel.isHidden = true
        posterView.layer.cornerRadius = 15
        alertView.layer.cornerRadius = 10
        navigationItem.title = movie.title
        
        let placeholder = UIImage(named: "movie-placeholder")
        let largeImageURL = URL(string: movie.largeImage!)
        if let largeImageURL = largeImageURL{
            posterView.sd_setImage(with: largeImageURL, placeholderImage: placeholder) { image, error, _, _ in
                if error != nil{
                    self.alertView.isHidden = false
                }
                
                if image != nil{
                    self.setDownloadTimeStamp()
                    self.alertView.isHidden = true
                }
            }
        }else{
            posterView.image = nil
        }
    }
    
    
    func setDownloadTimeStamp(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        downloadTimestampLabel.isHidden = false
        downloadTimestampLabel.text = "Изображение загружено: \n\(dateString)"
    }

}
