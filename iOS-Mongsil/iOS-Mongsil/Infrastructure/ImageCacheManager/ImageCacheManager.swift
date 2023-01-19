//
//  ImageCacheManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/05.
//

import Foundation
import UIKit.UIImage
import Combine

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache: ImageCacheProtocol
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        
        return queue
    }()
    
    private init() {
        self.cache = ImageCache()
    }
    
    func load(url: URL) -> AnyPublisher<UIImage?, Error> {
        if let image = cache[url] {
            return Future { promise in
                promise(.success(image))
            }.eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url as URL)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else { throw APIError.response }
                
                return data
            }
            .map({ [weak self] data in
                guard let self = self else { return nil }
                
                let image = UIImage(data: data)
                self.cache[url] = image
                
                return image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .share()
            .eraseToAnyPublisher()
    }
}
