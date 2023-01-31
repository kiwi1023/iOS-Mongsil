//
//  NotificationView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

protocol NotificationViewDelegate: AnyObject {
    func didTapToggleButton()
    func didTapTimeSelectButton()
}

final class NotificationView: SuperViewSetting {
    private enum NotificationViewNameSpace {
        static let toggleSwitchOn = "icSwitchOn"
        static let toggleSwitchOff = "icSwitchOff"
        static let alarmLabelText = "알림"
        static let selectTimeButtonTitle = "시간선택"
        static let textFont = "GamjaFlower-Regular"
    }
    
    private var isOnNotification = false
    private var buttonImage: UIImage? {
        isOnNotification ? UIImage(named: NotificationViewNameSpace.toggleSwitchOn) : UIImage(named: NotificationViewNameSpace.toggleSwitchOff)
    }
    weak var delegate: NotificationViewDelegate?
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: NotificationViewNameSpace.textFont, size: 23)
        label.text = NotificationViewNameSpace.alarmLabelText
        
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapToggleButton), for: .touchDown)
        
        return button
    }()
    
    private let selectTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NotificationViewNameSpace.selectTimeButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: NotificationViewNameSpace.textFont, size: 23)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(nil, action: #selector(didTapSelectTimeButton), for: .touchDown)
        
        return button
    }()
    
    func setupIsOnNotification(_ isOnNotification: Bool) {
        self.isOnNotification = isOnNotification
        setupIsHiddenView()
    }
    
    private func setupIsHiddenView() {
        selectTimeButton.isHidden = !isOnNotification
        toggleButton.setImage(buttonImage, for: .normal)
    }
    
    @objc
    private func didTapToggleButton() {
        delegate?.didTapToggleButton()
    }
    
    @objc
    private func didTapSelectTimeButton() {
        delegate?.didTapTimeSelectButton()
    }
    
    override func addUIComponents() {
        addSubview(alarmLabel)
        addSubview(toggleButton)
        addSubview(selectTimeButton)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            alarmLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            alarmLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectTimeButton.topAnchor.constraint(equalTo: alarmLabel.bottomAnchor, constant: 30),
            selectTimeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}
