//
//  FullImageViewController.swift
//  Gifka
//
//  Created by Александр on 04.07.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import SDWebImage

class FullImageViewController: UIViewController {

    @IBOutlet weak var fullGifImage: SDAnimatedImageView!
    var gifId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://media2.giphy.com/media/\(gifId)/giphy.gif") else { return }
        fullGifImage.sd_setImage(with: url, completed: nil)
    }
}
