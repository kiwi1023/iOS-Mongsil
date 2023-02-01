//
//  DiaryDTO.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import Foundation

struct DiaryDTO: Codable {
    let id: String
    let date: Date
    let url: String
    let squareUrl: String
}
