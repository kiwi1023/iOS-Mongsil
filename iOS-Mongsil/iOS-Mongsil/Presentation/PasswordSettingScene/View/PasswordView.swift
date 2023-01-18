//
//  PasswordView.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/18.
//

import UIKit

protocol PasswordViewDelegate: AnyObject {
    func didTapCloseButton()
}

class PasswordView: SuperViewSetting {
    weak var delegate: PasswordViewDelegate?
    
    override func setupDefault() {
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
    }
    
    override func addUIComponents() {
        addSubview(closeButton)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray
        
        return button
    }()
    
    @objc private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}
