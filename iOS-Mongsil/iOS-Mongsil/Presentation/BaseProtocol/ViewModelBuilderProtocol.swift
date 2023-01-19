//
//  ViewModelBuilderProtocol.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/06.
//

import Combine

protocol ViewModelBuilder {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
