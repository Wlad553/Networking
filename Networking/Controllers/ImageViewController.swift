//
//  ViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let url = "https://rare-gallery.com/uploads/posts/305053-Night-Sky-Stars-Mountain-Scenery-Milky-Way-4K.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    func fetchImage() {
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            guard let image = image else { return }
            self.imageView.image = image
        }
    }
}

