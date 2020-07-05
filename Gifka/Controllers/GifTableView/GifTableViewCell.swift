//
//  GifTableViewCell.swift
//  Gifka
//
//  Created by Александр on 04.07.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SDWebImage

let gifCache = NSCache<AnyObject, AnyObject>()

class GifTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var gifImage: SDAnimatedImageView!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var task: URLSessionDataTask!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        cardView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        activityIndicator.backgroundColor = .clear
    }
    
    func configure(with gifs: Gifs) {
        
        DispatchQueue.main.async {
            self.gifImage.image = nil
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        if let task = task {
            task.cancel()
        }
        
        guard let url = URL(string: "https://media2.giphy.com/media/\(gifs.id)/giphy.gif") else {
            return
        }
        
        if let gifFromCache = gifCache.object(forKey: url.absoluteString as AnyObject) as? SDAnimatedImage {
            DispatchQueue.main.async {
                self.gifImage.image = gifFromCache
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let newGIf = SDAnimatedImage(data: data) else { return }
            
            gifCache.setObject(newGIf, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.gifImage.image = newGIf
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        task.resume()
    }
}
