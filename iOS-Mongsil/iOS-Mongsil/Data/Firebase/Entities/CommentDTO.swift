//
//  CommentDTO.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/30.
//

import Foundation

struct CommentDTO: Codable {
    let id: UUID
    let date: Date
    var emoticon: String
    var text: String
}
