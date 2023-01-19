//
//  PasswordHeaderView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/18.
//
import UIKit

final class PasswordHeaderView: UIView {
    var signImageViews: [UIImageView] = []
    private var title: String
    
    init(frame: CGRect, title: String) {
        self.title = title
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        backgroundColor = .systemBackground
        titleLabel.text = self.title
    }
    
    private func addUIComponents() {
        addSubview(passwordHeaderStackView)
        [titleImageView, titleLabel, passwordSignImageStackView].forEach {
            passwordHeaderStackView.addArrangedSubview($0)
        }
        
        for _ in 0...3 {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.tintColor = UIColor(named: "passwordColor")
            
            passwordSignImageStackView.addArrangedSubview(imageView)
            signImageViews.append(imageView)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            passwordHeaderStackView.topAnchor.constraint(equalTo: topAnchor),
            passwordHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            passwordHeaderStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            passwordHeaderStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            passwordSignImageStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    let titleLabel: UILabel = {
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
        imageView.image = UIImage(named: "icPassword")
        
        return imageView
    }()
    
    private let passwordSignImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints=false
        stackView.alignment = .center
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let passwordHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints=false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
}
