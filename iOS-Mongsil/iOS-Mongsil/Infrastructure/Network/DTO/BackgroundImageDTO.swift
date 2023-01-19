//
//  BackgroundImageDTO.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/05.
//

import Foundation

struct BackgroundImageDTO: Decodable {
    let id: String
    let image: String
    let squareImage: String
}

extension BackgroundImageDTO {
    func toDomain() -> BackgroundImage {
        return .init(id: id,
                     image: image,
                     squareImage: squareImage)
    }
}
