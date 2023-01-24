//
//  CommentUpdateViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/22.
//

import UIKit

protocol CommentUpdateViewControllerDelegate: AnyObject {
    func didTapCloseButton()
    func didTapConfirmButton(indexPath: IndexPath, text: String)
}

final class CommentUpdateViewController: SuperViewControllerSetting {
    var indexPath: IndexPath?
    var text: String?
    weak var delegate: CommentUpdateViewControllerDelegate?
    private let commentUpdateView = CommentUpdateView()
    
    override func setupDefault() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        commentUpdateView.delegate = self
        commentUpdateView.setupTextView(text)
        setupKeyboardNotifications()
        setupTapGesture()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        view.frame.origin.y = -keyboardRectangle.height
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }

    override func addUIComponents() {
        view?.addSubview(commentUpdateView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            commentUpdateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            commentUpdateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            commentUpdateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            commentUpdateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension CommentUpdateViewController: CommentUpdateViewDelegate {
    func didTapCloseButton() {
        delegate?.didTapCloseButton()
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(text: String) {
        guard let indexPath = indexPath else { return }
        
        delegate?.didTapConfirmButton(indexPath: indexPath, text: text)
        dismiss(animated: true)
    }
}
