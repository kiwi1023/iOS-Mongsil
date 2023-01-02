//
//  Diary+Stub.swift
//  iOS-MongsilTests
//
//  Created by Kiwon Song on 2022/12/29.
//

import Foundation
@testable import iOS_Mongsil

extension Comment {
    static func stub(date: Date,
                     emoticon: Emoticon,
                     description: String) -> Self {
        Comment(date: date,
                emoticion: emoticon,
                description: description)
    }
}
