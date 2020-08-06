//
//  NetworkManager.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//Conform to the Error prototype
enum NetworkError: String, Error {
    case genericError = "Something went wrong. Please try again later"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
}


protocol NetworkServiceProtocol: class {
    func get<T: Codable>(with endRoute: NewsAPI, responseType: T.Type) -> Observable<T>
}


class NetworkManager: NetworkServiceProtocol {
    
    /// Single instance creation
    private init() {}
    static let shared = NetworkManager()
    
    /*
    func get<T>(with endRoute: NewsAPI, responseType: T.Type) -> Observable<T> where T : Decodable, T : Encodable {
        
        return Observable<T>.create { observer in
            
            let endPoint = NewsServerConstant.serverBaseURL.appendingPathComponent(endRoute.path).absoluteString.removingPercentEncoding
            
            /// Initialise with string.
            /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
            let url = URL(string: endPoint!)
            
            let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                // data received from server
                guard let data = data else {
                    return
                }
                
                let response = ResponseData(data: data)
                let decodedResponse = response.decode(responseType)
                
                guard let decodedData = decodedResponse.decodedData else {
                    return
                }
                
                observer.onNext(decodedData)
                observer.onCompleted()
            }
            session.resume()
        }
    }*/
    
    func get<T>(with endRoute: NewsAPI, responseType: T.Type) -> Observable<T> where T : Decodable, T : Encodable {
        return Observable<T>.create { observer in
            
            let endPoint = NewsServerConstant.serverBaseURL.appendingPathComponent(endRoute.path).absoluteString.removingPercentEncoding
            
            let url = URL(string: endPoint!)
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                let response = ResponseData(data: data)
                let decodedResponse = response.decode(responseType)
                guard let decodedData = decodedResponse.decodedData else {
                    return
                }
                observer.onNext(decodedData)
                
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
