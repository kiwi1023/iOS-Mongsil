//
//  NetworkRepository.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/12.
//

import Foundation
import Combine

final class BackgroundNetworkImageRepository: NetworkRepository {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func request() -> AnyPublisher<[BackgroundImage], Error> {
        let request = BackgroundImageRequest(method: .get,
                                             urlHost: .backgroundImage,
                                             path: .backgroundImages)
        
        return networkManager.backgroundImageDataTask(with: request)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
