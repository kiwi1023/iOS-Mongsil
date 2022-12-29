//
//  Diary.swift
//  iOS-Mongsil
//
//  Created by Groot on 2022/12/29.
//

import Foundation

struct Diary {
    let date: Date
    var url: String
    var isScrapped: Bool
    var comments: [Comment]
}

struct Comment {
    let date: Date
    var emoticion: Emoticon
    var description: String
}

enum Emoticon: String {
    case happy
    case pleasure
    case satisfied
    case notBad
    case tired
    case embarrassed
    case bored
    case angry
    case disgusting
    case disappointed
    case anxious
    case depressed
    case sad
    case surprised
    case lonely
    
    var name: String {
        return self.rawValue
    }
}

