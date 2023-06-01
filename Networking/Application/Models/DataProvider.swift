//
//  DataProvider.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 30/05/2023.
//

import UIKit
import Alamofire

class DataProvider: NSObject {
    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) -> Void)?
    var onProgress: ((Double) -> Void)?
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.vladyslavpetrenko.Networking")
//        config.isDiscretionary = true // iOS takes responsibility for planning data download
        config.sessionSendsLaunchEvents = true // app will be launched in background after data downloading
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        if let url = URL(string: "https://proof.ovh.net/files/100Mb.dat") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(1)
            downloadTask.countOfBytesClientExpectsToSend = 512 // upper bound, better to provide, so that iOS could better to handle it
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let completionHandler = appDelegate.bgSessionCompletionHandler
            else { return }
            
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
