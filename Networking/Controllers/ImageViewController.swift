//
//  ViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    func fetchImage() {
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "https://rare-gallery.com/uploads/posts/305053-Night-Sky-Stars-Mountain-Scenery-Milky-Way-4K.jpg") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        }.resume()
    }
}

