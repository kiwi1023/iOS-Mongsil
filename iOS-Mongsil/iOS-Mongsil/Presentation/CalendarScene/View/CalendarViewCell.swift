//
//  CalendarViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit

final class CalendarViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("CalendarViewCell Initialize error")
    }
    
    private func addUIComponents() {
        addSubview(dayLabel)
        addSubview(todayImageView)
        addSubview(emoticonImageView)
        addSubview(selectedStateImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            todayImageView.topAnchor.constraint(equalTo: self.topAnchor),
            todayImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            todayImageView.heightAnchor.constraint(equalToConstant: 10),
            todayImageView.widthAnchor.constraint(equalToConstant: 10)
        ])
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: todayImageView.bottomAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo:self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            selectedStateImageView.topAnchor.constraint(equalTo: todayImageView.bottomAnchor, constant: -5),
            selectedStateImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -5),
            selectedStateImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            selectedStateImageView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: 5)
        ])
        NSLayoutConstraint.activate([
            emoticonImageView.topAnchor.constraint(equalTo: todayImageView.bottomAnchor),
            emoticonImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emoticonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            emoticonImageView.bottomAnchor.constraint(equalTo:self.bottomAnchor)
        ])
    }
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "GamjaFlower-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    let todayImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints=false
        
        return imageView
    }()
    
    let selectedStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.opacity = 0.15
        
        return imageView
    }()
    
    let emoticonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func showIcon() {
        selectedStateImageView.isHidden = false
    }
    
    func hideIcon() {
        selectedStateImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        dayLabel.alpha = 1.0
        dayLabel.isHidden = false
        emoticonImageView.image = .none
        emoticonImageView.alpha = 1.0
    }
}

