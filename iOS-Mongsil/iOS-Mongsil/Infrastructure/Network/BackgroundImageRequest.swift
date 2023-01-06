//
//  BackgroundImageRequest.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/05.
//

import Foundation

struct BackgroundImageRequest: APIRequestProtocol {
    var method: HTTPMethod
    var urlHost: URLHost
    var headers: [String : String]?
    var query: [String : String]?
    var body: Data?
    var path: HTTPPath
}
