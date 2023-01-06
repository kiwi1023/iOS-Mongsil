//
//  ViewModelBuilderProtocol.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/06.
//

protocol ViewModelBuilder {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
