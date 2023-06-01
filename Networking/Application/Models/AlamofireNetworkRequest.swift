//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 31/05/2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completionHandler: @escaping (_ courses: [Course]) -> Void) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let courses: [Course] = Course.getArray(from: value)!
                completionHandler(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseData(url: String) {
        AF.request(url).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func responseString(url: String) {
        AF.request(url).responseString { stringResponse in
            switch stringResponse.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func response(url: String) {
        AF.request(url).response { response in
            guard let data = response.data,
                  let string = String(data: data, encoding: .utf8)
            else { return }
            print(string)
        }
    }
}
