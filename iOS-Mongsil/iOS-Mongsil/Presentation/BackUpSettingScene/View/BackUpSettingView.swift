//
//  BackUpSettingView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import UIKit

protocol BackUpSettingViewDelegate: AnyObject {
    func didTapRestorationLabel()
    func didTapLogoutLabel()
}

final class BackUpSettingView: SuperViewSetting {
    private enum LoginViewControllerNameSpace {
        static let userDefaultKeyValue = "BackupToggleState"
        static let fontText = "GamjaFlower-Regular"
        static let notifinationName = "Login"
        static let logoutLabelText = "애플 아이디 변경"
        static let setAutoBackupLabelText = "자동백업설정"
        static let restorationLabelText = "데이터 복구하기"
        static let switchOn = "icSwitchOn"
        static let switchOff = "icSwitchOff"
    }
    
    private var isTappedPasswordButton = UserDefaults.standard.bool(forKey: LoginViewControllerNameSpace.userDefaultKeyValue)
    weak var delegate: BackUpSettingViewDelegate?
    
    override func setupDefault() {
        setToggleImage()
        toggleButton.addTarget(self, action: #selector(setToggleButton), for: .touchDown)
        setupLabelGesture()
    }
    
    override func addUIComponents() {
        addSubview(setBackUpStackView)
        [setAutoBackupLabel, toggleButton].forEach {
            setBackUpStackView.addArrangedSubview($0)
        }
        addSubview(restorationLabel)
        addSubview(logoutLabel)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            setBackUpStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            setBackUpStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setBackUpStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            setBackUpStackView.heightAnchor.constraint(equalToConstant: 65),
            toggleButton.widthAnchor.constraint(equalToConstant: 47)
        ])
        NSLayoutConstraint.activate([
            restorationLabel.topAnchor.constraint(equalTo: setBackUpStackView.bottomAnchor),
            restorationLabel.heightAnchor.constraint(equalToConstant: 65),
            restorationLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            restorationLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            logoutLabel.topAnchor.constraint(equalTo: restorationLabel.bottomAnchor),
            logoutLabel.heightAnchor.constraint(equalToConstant: 65),
            logoutLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logoutLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private let setBackUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let logoutLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: LoginViewControllerNameSpace.fontText, size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LoginViewControllerNameSpace.logoutLabelText
       
        return label
    }()
    
    private let setAutoBackupLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: LoginViewControllerNameSpace.fontText, size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LoginViewControllerNameSpace.setAutoBackupLabelText
        
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let restorationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: LoginViewControllerNameSpace.fontText, size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LoginViewControllerNameSpace.restorationLabelText
        
        return label
    }()
    
    private func setupLabelGesture() {
        let restorationGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapRestorationLabelButton)
        )
        
        restorationLabel.addGestureRecognizer(restorationGesture)
        restorationLabel.isUserInteractionEnabled = true
        
        let logoutGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapLogoutLabelButton)
        )
        
        logoutLabel.addGestureRecognizer(logoutGesture)
        logoutLabel.isUserInteractionEnabled = true
    }
    
    @objc private func didTapRestorationLabelButton() {
        delegate?.didTapRestorationLabel()
    }
    
    @objc private func didTapLogoutLabelButton() {
        delegate?.didTapLogoutLabel()
    }
    
    private func setToggleImage() {
        if isTappedPasswordButton {
            toggleButton.setImage(UIImage(named: LoginViewControllerNameSpace.switchOn), for: .normal)
        } else {
            toggleButton.setImage(UIImage(named: LoginViewControllerNameSpace.switchOff), for: .normal)
        }
    }
    
    @objc private func setToggleButton() {
        isTappedPasswordButton.toggle()
        isTappedPasswordButton ? toggleButton.setImage(UIImage(named: LoginViewControllerNameSpace.switchOn),
                                                       for: .normal) : toggleButton.setImage(UIImage(named: LoginViewControllerNameSpace.switchOff), for: .normal)
        UserDefaults.standard.set(self.isTappedPasswordButton, forKey: LoginViewControllerNameSpace.userDefaultKeyValue)
    }
}

