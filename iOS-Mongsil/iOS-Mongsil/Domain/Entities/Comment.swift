//
//  Comment.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/04.
//

import Foundation
import UIKit.UIColor
import UIKit.UIImage

struct Comment {
    let id: UUID
    let date: Date
    var emoticon: Emoticon
    var text: String
}

enum Emoticon: String, CaseIterable{
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
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    var label: String {
        switch self {
        case .happy:
            return "행복"
        case .pleasure:
            return "기쁨"
        case .satisfied:
            return "만족"
        case .notBad:
            return "보통"
        case .tired:
            return "피곤"
        case .embarrassed:
            return "창피"
        case .bored:
            return "지루함"
        case .angry:
            return "화남"
        case .disgusting:
            return "불쾌"
        case .disappointed:
            return "실망"
        case .anxious:
            return "불안"
        case .depressed:
            return "우울"
        case .sad:
            return "슬픔"
        case .surprised:
            return "놀람"
        case .lonely:
            return "외로움"
        }
    }
    
    var labelColor: UIColor? {
        return UIColor(named: self.rawValue + "LabelColor")
    }
    
    var backgroundColor: UIColor? {
        return UIColor(named: self.rawValue + "BackgroundColor")
    }
}
