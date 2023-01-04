//
//  Comment.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/04.
//

import Foundation

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
