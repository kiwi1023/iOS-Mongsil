//
//  DefualtNetworkUseCase.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/12.
//

import Foundation
import Combine

protocol NetworkUseCase {
    func request() -> AnyPublisher<[BackgroundImage], Error>
}

final class DefaultNetworkUseCase: NetworkUseCase {
    let networkRepository: NetworkRepository
    
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    
    func request() -> AnyPublisher<[BackgroundImage], Error> {
        networkRepository.request()
    }
}
