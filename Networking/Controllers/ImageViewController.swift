//
//  ViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url = "https://rare-gallery.com/uploads/posts/305053-Night-Sky-Stars-Mountain-Scenery-Milky-Way-4K.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
    }
    
    func fetchImage() {
        NetworkManager.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            guard let image = image else { return }
            self.imageView.image = image
        }
    }
    
    func fetchDataWithAlamofire() {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

