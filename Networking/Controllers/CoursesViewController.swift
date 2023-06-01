//
//  CoursesViewController.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    
    @IBOutlet weak var tableView: UITableView!
    
    func fetchData() {
//        let jsonURLString = "https://swiftbook.ru//wp-content/uploads/api/api_course"
//        let jsonURLString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
//        let jsonURLString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        NetworkManager.fetchData(urlString: url) { courses in
            self.courses = courses
            self.tableView.reloadData()
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(url: url) { courses in
            self.courses = courses
            self.tableView.reloadData()
        }
    }
    
    private func configureCell(_ cell: TableViewCell, forRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
        cell.courseNameLabel.text = course.name
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }

}

// MARK: Table View Data Source

extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else { fatalError("couldn't create a cell") }
        configureCell(cell, forRowAt: indexPath)
        return cell
    }
}

// MARK: Table View Delegate

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "goToWebView", sender: self)
    }
}
