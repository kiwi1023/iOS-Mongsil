//
//  EmoticonsViewController.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/11.
//

import UIKit

final class EmoticonsViewController: SuperViewControllerSetting {
    private var viewModel: EmoticonsViewModel
    private let emoticonsView = EmoticonsView()
    
    init(viewModelDelegate: EmocitonsViewModelDelegate, indexPath: IndexPath? = nil) {
        viewModel = EmoticonsViewModel(indexPath: indexPath)
        viewModel.delegate = viewModelDelegate
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupDefault() {
        emoticonsView.setupCollecntionViewDelegate(self)
    }
    
    override func addUIComponents() {
        view.addSubview(emoticonsView)
    }
    
    override func setupLayout() {
        emoticonsView.setupCollectionViewLayout(createLayout())
        NSLayoutConstraint.activate(
            [
                emoticonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                emoticonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                emoticonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                emoticonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemInset = 20.0
        let emoticonsViewInset = 30
        let calculatedGroupSize = (view.frame.width - itemInset * 2.0 - Double(emoticonsViewInset)) * 0.3
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(calculatedGroupSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 3)
        group.interItemSpacing = .fixed(itemInset)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20.0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension EmoticonsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoticonCollectionViewCell",
                                                            for: indexPath) as? EmoticonCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setupItem(emoticon: viewModel.emoticons[indexPath.row])
        
        return cell
    }
}

extension EmoticonsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapCollectionViewCell(index: indexPath.row)
        dismiss(animated: true)
    }
}

extension EmoticonsViewController: EmoticonsViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}
