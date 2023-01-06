//
//  MockNetworkManager.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/05.
//

import Foundation
import Combine
@testable import iOS_Mongsil

final class MockNetworkManager: NetworkManagerProtocol {
    let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func backgroundImageDataTask(with request: iOS_Mongsil.APIRequestProtocol) -> AnyPublisher<[BackgroundImageDTO], Error> {
        guard let data = MockNetworkData(fileName: "BackGroundImage").data else {
            return Fail<[BackgroundImageDTO],Error>(error: APIError.request)
                .eraseToAnyPublisher()
        }
        
        return Future<[BackgroundImageDTO], Error> { [weak self] promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                guard let self = self else { return }
                let backgroundImages = try! JSONDecoder().decode([BackgroundImageDTO].self, from: data)
                
                if self.isSuccess {
                    promise(.success(backgroundImages))
                    
                    return
                }
                
                promise(.failure(APIError.response))
            }
        }
        .eraseToAnyPublisher()
    }
}
