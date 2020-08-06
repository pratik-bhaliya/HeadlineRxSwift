//
//  EndPoint.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation

// News server constant
struct NewsServerConstant {
    static let serverBaseURL =  URL(string: "https://newsapi.org/v2/")!
    static let NewsAPIKey = "02ebfe96395d45c0a3551c4b12d182b5"
    static let serverTimeout = 30.0
}

// List of News API
public enum NewsAPI {
    case topHeadline
    case sources
    case topHeadlineBySource(sourceName: String)
}

extension NewsAPI: EndPointType {
    
    var path: String {
        switch self {
        case .topHeadline:
            return "top-headlines?country=au&apiKey=\(NewsServerConstant.NewsAPIKey)"
        case .sources:
            return "sources?language=en&apiKey=\(NewsServerConstant.NewsAPIKey)"
        case .topHeadlineBySource(let sourceName):
            return "top-headlines?sources=\(sourceName)&apiKey=\(NewsServerConstant.NewsAPIKey)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}
