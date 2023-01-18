//
//  NotificationView.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/17.
//

import UIKit

protocol NotificationViewDelegate: AnyObject {
    func didTapToggleButton()
    func didTapChevronButton()
}

final class NotificationView: SuperViewSetting {
    private var isOnNotification = false
    private var buttonImage: UIImage? {
        isOnNotification ? UIImage(named: "icSwitchOn") : UIImage(named: "icSwitchOff")
    }
    weak var delegate: NotificationViewDelegate?
    
    private let alarmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.text = "알림"
        
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapToggleButton), for: .touchDown)
        
        return button
    }()
    
    private let selectTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GamjaFlower-Regular", size: 23)
        label.text = "시간 선택"
        
        return label
    }()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapChevronButton), for: .touchDown)
        button.setImage(UIImage(named: "icCloseCopy"), for: .normal)
        
        return button
    }()
    
    func setupIsOnNotification(_ isOnNotification: Bool) {
        self.isOnNotification = isOnNotification
        setupIsHiddenView()
    }
    
    private func setupIsHiddenView() {
        selectTimeLabel.isHidden = !isOnNotification
        chevronButton.isHidden = !isOnNotification
        toggleButton.setImage(buttonImage, for: .normal)
    }
    
    @objc
    private func didTapToggleButton() {
        delegate?.didTapToggleButton()
    }
    
    @objc
    private func didTapChevronButton() {
        delegate?.didTapChevronButton()
    }
    
    override func addUIComponents() {
        addSubview(alarmLabel)
        addSubview(toggleButton)
        addSubview(selectTimeLabel)
        addSubview(chevronButton)
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
            selectTimeLabel.topAnchor.constraint(equalTo: alarmLabel.bottomAnchor, constant: 30),
            selectTimeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            chevronButton.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: 30),
            chevronButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
