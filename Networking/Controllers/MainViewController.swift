//
//  MainViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case upload = "Upload Image"
}

private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"

class MainViewController: UICollectionViewController {
    
//    let actions = [
//        "Download Image",
//        "GET",
//        "POST",
//        "Our Courses",
//        "Upload Image"
//    ]
    let actions = Actions.allCases
    
    override func viewDidLoad() {
        layoutSetup()
    }
    
    func layoutSetup() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        layout.itemSize = CGSize(width: view.frame.width - 32, height: 80)
        layout.minimumLineSpacing = 20
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(urlString: url)
        case .post:
            NetworkManager.postRequest(urlString: url)
        case .ourCourses:
            performSegue(withIdentifier: "showOurCourses", sender: self)
        case .upload:
            NetworkManager.uploadImage(url: uploadImage)
        }
    }
    
    
}
