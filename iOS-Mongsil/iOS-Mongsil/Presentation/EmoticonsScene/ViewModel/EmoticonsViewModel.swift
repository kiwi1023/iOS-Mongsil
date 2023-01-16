//
//  EmoticonsViewModel.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/11.
//

import Combine
import Foundation

protocol EmocitonsViewModelDelegate: AnyObject {
    func didTapCollectionViewCell(_ selectedEmoticon: Emoticon)
    func didTapCollectionViewCell(_ selectedEmoticon: Emoticon, indexPath: IndexPath)
}

struct EmoticonsViewModel {
    weak var delegate: EmocitonsViewModelDelegate?
    private var indexPath: IndexPath?
    let emoticons = Emoticon.allCases
    
    init(indexPath: IndexPath? = nil) {
        self.indexPath = indexPath
    }
    
    func didTapCollectionViewCell(index: Int) {
        if let indexPath = self.indexPath {
            delegate?.didTapCollectionViewCell(emoticons[index], indexPath: indexPath)
            
            return
        }
        
        delegate?.didTapCollectionViewCell(emoticons[index])
    }
}
