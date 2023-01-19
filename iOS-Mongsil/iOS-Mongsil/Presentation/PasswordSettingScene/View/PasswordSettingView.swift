//
//  PasswordSettingView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

protocol PassswordSettingViewDelegate: AnyObject {
    func didTapToggleButton()
    func didTapEditPasswordLabel()
}

final class PasswordSettingView: SuperViewSetting {
    private var isTappedPasswordButton = UserDefaults.standard.bool(forKey: "toggleState")
    weak var delegate: PassswordSettingViewDelegate?
    
    override func setupDefault() {
        editPasswordLabel.alpha = 0
        setToggleImage()
        toggleButton.addTarget(self, action: #selector(setIsTappedPasswordButton), for: .touchDown)
        setNotification()
        setupImageViewGesture()
    }
    
    override func addUIComponents() {
        addSubview(warningLabel)
        addSubview(setPasswordStackView)
        [setPasswordLabel, toggleButton].forEach {
            setPasswordStackView.addArrangedSubview($0)
        }
        addSubview(editPasswordLabel)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            warningLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            warningLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            setPasswordStackView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor),
            setPasswordStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setPasswordStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            setPasswordStackView.heightAnchor.constraint(equalToConstant: 65),
            toggleButton.widthAnchor.constraint(equalToConstant: 47)
        ])
        
        NSLayoutConstraint.activate([
            editPasswordLabel.topAnchor.constraint(equalTo: setPasswordStackView.bottomAnchor),
            editPasswordLabel.heightAnchor.constraint(equalToConstant: 65),
            editPasswordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editPasswordLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private let setPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "GamjaFlower-Regular", size: 15)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "! 암호를 분실했을 경우 앱을 삭제하고 재설치 해야하며, \n 재설치 시 기존 다이어리 내용은 삭제 됩니다. !"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let setPasswordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "앱화면잠금"
        
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let editPasswordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호 변경"
        
        return label
    }()
    
    private func setupImageViewGesture() {
        let editPasswordGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapEditPasswordLabelButton)
        )
        
        editPasswordLabel.addGestureRecognizer(editPasswordGesture)
        editPasswordLabel.isUserInteractionEnabled = true
    }
    
    @objc private func didTapEditPasswordLabelButton() {
        delegate?.didTapEditPasswordLabel()
    }
    
    private func setToggleImage() {
        if isTappedPasswordButton {
            toggleButton.setImage(UIImage(named: "icSwitchOn"), for: .normal)
            self.editPasswordLabel.alpha = 1.0
        } else {
            toggleButton.setImage(UIImage(named: "icSwitchOff"), for: .normal)
            self.editPasswordLabel.alpha = 0.0
        }
    }
    
    @objc private func setIsTappedPasswordButton() {
        setToggleButton()
        
        if isTappedPasswordButton == true {
            delegate?.didTapToggleButton()
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setToggleButton),
            name: Notification.Name("SetToggle"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setToggleButton),
            name: Notification.Name("SwitchTurnOff"),
            object: nil
        )
    }
    
    @objc private func setToggleButton() {
        isTappedPasswordButton.toggle()
        isTappedPasswordButton ? toggleButton.setImage(UIImage(named: "icSwitchOn"),
                                                       for: .normal) : toggleButton.setImage(UIImage(named: "icSwitchOff"), for: .normal)
        UserDefaults.standard.set(self.isTappedPasswordButton, forKey: "toggleState")
        
        if isTappedPasswordButton {
            UIView.animate(withDuration: 0.2, delay: 0.0,
                           options: .curveEaseIn,
                           animations: {
                self.editPasswordLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0,
                           options: .curveEaseIn,
                           animations: {
                self.editPasswordLabel.alpha = 0.0
                KeyChainManger.shared.deleteItemOnKeyChain()
            })
        }
    }
}
