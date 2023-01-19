//
//  SessionProtocol.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/04.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func backgroundImageDataTask(with request: APIRequestProtocol) -> AnyPublisher<[BackgroundImageDTO], Error>
}
