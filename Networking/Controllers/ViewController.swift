//
//  ViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getImagePressed(_ sender: UIButton) {
        label.isHidden = true
        getImageButton.isEnabled = false
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "https://rare-gallery.com/uploads/posts/305053-Night-Sky-Stars-Mountain-Scenery-Milky-Way-4K.jpg") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.label.isHidden = false
                    self.getImageButton.isEnabled = true
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

