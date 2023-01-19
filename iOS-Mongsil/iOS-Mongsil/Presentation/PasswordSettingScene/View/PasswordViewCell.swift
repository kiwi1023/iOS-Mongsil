//
//  PasswordView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/18.
//

import UIKit

final class PasswordViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("PasswordViewCell Initialize error")
    }
    
    private func addUIComponents() {
        addSubview(numberLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            numberLabel.bottomAnchor.constraint(equalTo:self.bottomAnchor)
        ])
    }
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "GamjaFlower-Regular", size: 25)
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
}

