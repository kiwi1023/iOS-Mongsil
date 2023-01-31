//
//  CommentUpdateView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/22.
//

import UIKit

protocol CommentUpdateViewDelegate: AnyObject {
    func didTapCloseButton()
    func didTapConfirmButton(text: String)
}

final class CommentUpdateView: SuperViewSetting {
    private enum CommentUpdateViewNameSpace {
        static let fontText = "NanumSeHwaCe"
        static let okButtonTitle = "확인"
        static let cancelButtonTitle = "취소"
    }
    
    weak var delegate: CommentUpdateViewDelegate?

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layer.cornerRadius = 25
        
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        return stackView
    }()

    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 20
        textView.layer.borderColor = UIColor.white.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        textView.font = UIFont(name: CommentUpdateViewNameSpace.fontText, size: 23.0)
        textView.backgroundColor = UIColor.black.withAlphaComponent(0)
        textView.textColor = .white
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapCloseButton), for: .touchDown)
        button.setTitle(CommentUpdateViewNameSpace.cancelButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: CommentUpdateViewNameSpace.fontText, size: 23.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapConfirmButton), for: .touchDown)
        button.setTitle(CommentUpdateViewNameSpace.okButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: CommentUpdateViewNameSpace.fontText, size: 23.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        return button
    }()
    
    func setupTextView(_ text: String?) {
        commentTextView.text = text
    }

    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }

    @objc
    private func didTapConfirmButton() {
        delegate?.didTapConfirmButton(text: commentTextView.text)
    }

    override func setupDefault() {
        backgroundColor = UIColor.black.withAlphaComponent(0)
        layer.cornerRadius = 25
    }

    override func addUIComponents() {
        addSubview(mainStackView)
        [commentTextView, horizontalStackView].forEach { mainStackView.addArrangedSubview($0) }
        [closeButton, confirmButton].forEach { horizontalStackView.addArrangedSubview($0) }
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            horizontalStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.15)
        ])
    }
}

