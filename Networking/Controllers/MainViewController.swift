//
//  MainViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Courses"
    case upload = "Upload Image"
    case downloadFile =  "Download File"
    case ourCoursesAlamofire = "Courses (Alamofire)"
    case responseData = "responseData"
    case responseString = "responseString"
    case response = "response"
}

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    private let postsURL = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImage = "https://api.imgur.com/3/image"
    private let coursesURL = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    
    override func viewDidLoad() {
        layoutSetup()
        registerForNotification()
        dataProvider.fileLocation = { locationPath in
            self.filePath = locationPath.absoluteString
            self.postNotification()
            self.alert.dismiss(animated: true)
        }
    }
    
    func layoutSetup() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 80)
        layout.minimumLineSpacing = 20
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let alertHeightConstraint = NSLayoutConstraint(item: alert.view!,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 0,
                                                       constant: 170)
        alert.view.addConstraint(alertHeightConstraint)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .blue
        self.dataProvider.onProgress = { progress in
            progressView.setProgress(Float(progress), animated: true)
            self.alert.message = "\(Int(progress * 100))%"
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        self.alert.view.addSubview(activityIndicator)
        self.alert.view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: self.alert.view.centerYAnchor, constant: alertHeightConstraint.constant / 2 - 44),
            progressView.widthAnchor.constraint(equalTo: self.alert.view.widthAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor)
        ])
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch segue.identifier {
        case "showOurCourses":
            coursesVC?.fetchData()
        case "ourCoursesAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "showImage":
            imageVC?.fetchImage()
        case "responseData":
            imageVC?.fetchDataWithAlamofire()
            AlamofireNetworkRequest.responseData(url: coursesURL)
        default: break
        }
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController {
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
}

// MARK: UICollectionViewDelegate
extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(urlString: postsURL)
        case .post:
            NetworkManager.postRequest(urlString: postsURL)
        case .ourCourses:
            performSegue(withIdentifier: "showOurCourses", sender: self)
        case .upload:
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "ourCoursesAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "responseData", sender: self)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: coursesURL)
        case .response:
            AlamofireNetworkRequest.response(url: coursesURL)
        }
    }
}

// MARK: UNUserNotificationCenter
extension MainViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {_,_ in}
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has been completed. File path: \(filePath!)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferCompleted", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
