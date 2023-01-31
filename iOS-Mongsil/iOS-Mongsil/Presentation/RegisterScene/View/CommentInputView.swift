//
//  CommentInputView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/13.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func didTapAddCommentButton(_ comment: String)
    func didTapEmoticonButton()
}

final class CommentInputView: SuperViewSetting {
    private enum CommentInputViewNameSpace {
        static let fontText = "NanumSeHwaCe"
        static let okText = "확인"
        static let textViewText = "오늘의 기분을 입력해주세요."
    }
    
    private weak var delegate: CommentInputViewDelegate?
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let emoticonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.black.withAlphaComponent(0)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 20
        textView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        textView.textColor = .white
        textView.text = CommentInputViewNameSpace.textViewText
        textView.font = UIFont(name: CommentInputViewNameSpace.fontText, size: 23.0)
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    private let addCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setTitle(CommentInputViewNameSpace.okText, for: .normal)
        button.titleLabel?.font = UIFont(name: CommentInputViewNameSpace.fontText, size: 22.0)
        
        return button
    }()
    
    func setupDelegates(_ viewController: UIViewController) {
        commentTextView.delegate = viewController as? UITextViewDelegate
        delegate = viewController as? CommentInputViewDelegate
    }
    
    func setupEmoticonImageView(_ emoticon: Emoticon) {
        emoticonButton.setImage(emoticon.image, for: .normal)
        emoticonButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func commentTextViewMaxHeight() -> CGFloat {
        let size = CGSize(width: commentTextView.frame.width, height: .infinity)
        let estimatedSize = commentTextView.sizeThatFits(size)
        
        return estimatedSize.height + (commentTextView.font?.lineHeight.rounded() ?? 0) * 3
    }
    
    override func setupDefault() {
        backgroundColor = UIColor.black.withAlphaComponent(0)
        addCommentButton.addTarget(self, action: #selector(didTapAddCommentButton), for: .touchDown)
        emoticonButton.addTarget(self, action: #selector(didTapEmoticonButton), for: .touchDown)
    }
    
    @objc
    private func didTapAddCommentButton() {
        guard commentTextView.text != nil &&
                commentTextView.text != "" &&
                commentTextView.text != CommentInputViewNameSpace.textViewText else { return }
        
        delegate?.didTapAddCommentButton(commentTextView.text ?? "")
        commentTextView.text = nil
        let size = CGSize(width: commentTextView.frame.width, height: .infinity)
        let estimatedSize = commentTextView.sizeThatFits(size)
        commentTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    @objc
    private func didTapEmoticonButton() {
        delegate?.didTapEmoticonButton()
    }
    
    override func addUIComponents() {
        addSubview(horizontalStackView)
        [emoticonButton, commentTextView, addCommentButton].forEach { horizontalStackView.addArrangedSubview($0) }
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
                horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
                horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            commentTextView.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.75),
            commentTextView.heightAnchor.constraint(equalToConstant: commentTextViewMaxHeight() / 2.68)
            ])
    }
}
