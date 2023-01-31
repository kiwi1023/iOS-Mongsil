//
//  FavoriteView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit
import Combine

final class FavoriteView: SuperViewSetting {
    private enum FavoriteViewNameSpace {
        static let cellIdentifier = "FavoriteCell"
    }
    
    private var favoriteCollectionView: UICollectionView! = nil
    var diaries: [Diary] = [] {
        didSet {
            favoriteCollectionView.reloadData()
        }
    }
    var didTapcell: ((Diary) -> ())?
    
    private let favoriteLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }()
    
    func getDiaryData(data: [Diary]) {
        self.diaries = data
    }
    
    override func setupDefault() {
        configurationCollectionView()
    }
    
    private func configurationCollectionView() {
        favoriteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: favoriteLayout)
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(FavoriteViewCell.self, forCellWithReuseIdentifier: FavoriteViewNameSpace.cellIdentifier)
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.showsVerticalScrollIndicator = false
    }
    
    override func addUIComponents() {
        addSubview(favoriteCollectionView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            favoriteCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            favoriteCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            favoriteCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoriteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteViewNameSpace.cellIdentifier,
                                                      for: indexPath) as! FavoriteViewCell
        
        cell.configure(data: diaries[indexPath.item])
        return cell
    }
}

extension FavoriteView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.favoriteCollectionView.bounds.width * 1/3
        let height = width
        let itemSize = CGSize(width: width, height: height)
        
        return itemSize
    }
}

extension FavoriteView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapcell?(diaries[indexPath.item])
    }
}
