//
//  ResponseData.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ResponseData {
    
    fileprivate var data: Data
    
    init(data: Data) {
        self.data = data
    }
}

// Generic ways to decode as expected type
extension ResponseData {
    public func decode<T: Codable>(_ type: T.Type) -> (decodedData: T?, error: Error?) {
        
        // do-catch statement to throw and catch errors
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return (response, nil)
        } catch let error {
            print(error.localizedDescription)
            return (nil, error)
        }
    }
}


// MARK: - Singleton saving session source
struct SelectedSource {
    private init() { }
    static var shared = SelectedSource()
    var collectionArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
}
