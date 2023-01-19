//
//  APIConfiguration.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/04.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var type: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}

enum URLHost {
    case backgroundImage
    
    var url: String {
        switch self {
        case .backgroundImage:
            return "https://haeseong5.github.io"
        }
    }
}

enum HTTPPath {
    case backgroundImages
    
    var value: String {
        switch self {
        case .backgroundImages:
            return "/api/saying.json"
        }
    }
}
