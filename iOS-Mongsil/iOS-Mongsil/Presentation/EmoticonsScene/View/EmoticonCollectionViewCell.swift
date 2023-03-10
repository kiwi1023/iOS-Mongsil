//
//  EmoticonCollectionViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/11.
//

import UIKit

final class EmoticonCollectionViewCell: UICollectionViewCell {
    private enum EmoticonCollectionViewCellNameSpace {
        static let fontText = "GamjaFlower-Regular"
    }
    
    private let emoticonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let emoticonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: EmoticonCollectionViewCellNameSpace.fontText, size: 18.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("EmoticonCollectionViewCell Initialize error")
    }
    
    func setupItem(emoticon: Emoticon) {
        contentView.backgroundColor = emoticon.backgroundColor
        emoticonImageView.image = emoticon.image
        emoticonLabel.text = emoticon.label
        emoticonLabel.textColor = emoticon.labelColor
        emoticonLabel.sizeToFit()
    }
    
    private func setupDefault() {
        contentView.layer.cornerRadius = 25
    }
    
    private func addUIComponents() {
        contentView.addSubview(emoticonImageView)
        contentView.addSubview(emoticonLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
                emoticonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emoticonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
                emoticonImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        NSLayoutConstraint.activate([
                emoticonLabel.topAnchor.constraint(equalTo: emoticonImageView.bottomAnchor, constant: 4),
                emoticonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
}
