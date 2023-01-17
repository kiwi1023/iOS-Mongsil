//
//  SettingViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

final class SettingViewCell: UICollectionViewCell {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    private func addUIComponents() {
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(chevronImage)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            titleImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            chevronImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            chevronImage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            chevronImage.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    func configure(text: String, image: String, needChevronImage: Bool) {
        titleLabel.text = text
        titleImageView.image = UIImage(named: image)
        if needChevronImage {
            chevronImage.image = UIImage(named: "icCloseCopy")
        }
    }
    
    override func prepareForReuse() {
     
    }
}
