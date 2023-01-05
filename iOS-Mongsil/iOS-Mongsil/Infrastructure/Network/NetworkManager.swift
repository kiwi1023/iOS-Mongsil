//
//  NetworkManager.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/04.
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    func backgroundImageDataTask(with request: APIRequestProtocol) -> AnyPublisher<[BackgroundImageDTO], Error> {
        guard let url = request.url else {
            return Fail<[BackgroundImageDTO],Error>(error: APIError.request)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 &&
                        response.statusCode < 300 else {
                    throw APIError.response
                }
                return data
            }
            .decode(type: [BackgroundImageDTO].self, decoder: JSONDecoder())
            .share()
            .eraseToAnyPublisher()
    }
}
