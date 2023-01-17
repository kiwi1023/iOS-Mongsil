//
//  EmoticonCollectionViewCell.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/11.
//

import UIKit

final class EmoticonCollectionViewCell: UICollectionViewCell {
    private let emoticonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let emoticonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        NSLayoutConstraint.activate(
            [
                emoticonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emoticonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
                emoticonImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        NSLayoutConstraint.activate(
            [
                emoticonLabel.topAnchor.constraint(equalTo: emoticonImageView.bottomAnchor, constant: 4),
                emoticonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
}
