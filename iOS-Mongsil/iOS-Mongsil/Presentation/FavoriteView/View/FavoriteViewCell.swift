//
//  FavoriteViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/16.
//

import UIKit
import Combine

final class FavoriteViewCell: UICollectionViewCell {
    private var cancellables = Set<AnyCancellable>()
    
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
        addSubview(squareImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            squareImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            squareImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            squareImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            squareImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private let squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func configure(data: Diary) {
        guard let url = URL(string: data.squareUrl) else { return }
        
        ImageCacheManager.shared.load(url: url).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] image in
            guard let self = self else { return }
            
            self.squareImageView.image = image
        }.store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        squareImageView.image = nil
        cancellables.removeAll()
    }
}


