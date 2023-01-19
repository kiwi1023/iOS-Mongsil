//
//  EmoticonsCollectionView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/11.
//

import UIKit

protocol EmoticonsViewDelegate: NSObject {
    func didTapCloseButton()
}

final class EmoticonsView: SuperViewSetting {
    private weak var delegate: EmoticonsViewDelegate?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 24
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GamjaFlower-Regular", size: 26.0)
        label.text = "오늘 기분은 어때요?"
        
        return label
    }()
    
    private let emoticonCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EmoticonCollectionViewCell.self,
                                forCellWithReuseIdentifier: "EmoticonCollectionViewCell")
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("EmoticonsView Initialize error")
    }
    
    required init() {
        super.init()
    }
    
    func setupCollectionViewLayout(_ layout: UICollectionViewLayout) {
        emoticonCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupCollectionViewDelegate(_ viewController: UIViewController) {
        emoticonCollectionView.delegate = viewController as? UICollectionViewDelegate
        emoticonCollectionView.dataSource = viewController as? UICollectionViewDataSource
        delegate = viewController as? EmoticonsViewDelegate
    }
    
    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
    
    override func setupDefault() {
        backgroundColor = UIColor.black.withAlphaComponent(0)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
    }
    
    override func addUIComponents() {
        addSubview(closeButton)
        addSubview(mainStackView)
        [titleLabel, emoticonCollectionView].forEach { mainStackView.addArrangedSubview($0) }
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: topAnchor),
                closeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30),
                mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
