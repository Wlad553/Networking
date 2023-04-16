//
//  NetworkManager.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import UIKit

class NetworkManager {
    
    private init() {}
    
    class func getRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data
            else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    class func postRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let userData = ["Course": "Networking", "Lesson": "GET and POST Requests"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // try to delete and see what happens
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let response = response,
                  let data = data
            else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    class func downloadImage(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                print(error as Any)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    class func fetchData(urlString: String, completion: @escaping ([Course]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //                let course = try decoder.decode(Course.self, from: data)
                let courses = try decoder.decode([Course].self, from: data)
                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                DispatchQueue.main.async {
                    completion(courses)
                }
            } catch let error {
                print("Error serialization json: \(error)")
            }
            
        }.resume()
    }
}
