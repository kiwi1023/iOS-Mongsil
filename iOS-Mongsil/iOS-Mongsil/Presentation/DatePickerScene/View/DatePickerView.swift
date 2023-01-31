//
//  DatePickerView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func didTapCloseButton()
    func didTapConfirmButton(components: DateComponents)
}

final class DatePickerView: SuperViewSetting {
    private enum DatePickerViewNameSpace {
        static let textFont = "GamjaFlower-Regular"
        static let closeButtonColor = "closeButtonColor"
        static let confirmButtonColor = "confirmButtonColor"
        static let closeButtonBackgroundColor = "closeButtonBackgroundColor"
        static let confirmButtonBackgroundColor = "confirmButtonBackgroundColor"
        static let okMessage = "확인"
        static let cancelMessage = "취소"
    }
    
    weak var delegate: DatePickerViewDelegate?

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 25
        
        return stackView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        return stackView
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapCloseButton), for: .touchDown)
        button.setTitle(DatePickerViewNameSpace.cancelMessage, for: .normal)
        button.titleLabel?.font = UIFont(name: DatePickerViewNameSpace.textFont, size: 23)
        button.setTitleColor(UIColor(named: DatePickerViewNameSpace.closeButtonColor), for: .normal)
        button.backgroundColor = UIColor(named: DatePickerViewNameSpace.closeButtonBackgroundColor)
        button.layer.cornerRadius = 25
        
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(didTapConfirmButton), for: .touchDown)
        button.setTitle(DatePickerViewNameSpace.okMessage, for: .normal)
        button.titleLabel?.font = UIFont(name: DatePickerViewNameSpace.textFont, size: 23)
        button.setTitleColor(UIColor(named: DatePickerViewNameSpace.confirmButtonColor), for: .normal)
        button.backgroundColor = UIColor(named: DatePickerViewNameSpace.confirmButtonBackgroundColor)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    func setupDatePicker(date: Date?) {
        guard let date = date else { return }
        
        datePicker.date = date
    }

    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }

    @objc
    private func didTapConfirmButton() {
        let components = datePicker.calendar.dateComponents([.hour, .minute],
                                                            from: datePicker.date)
        delegate?.didTapConfirmButton(components: components)
    }

    override func setupDefault() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 25
    }

    override func addUIComponents() {
        addSubview(mainStackView)
        [datePicker, horizontalStackView].forEach { mainStackView.addArrangedSubview($0) }
        [closeButton, confirmButton].forEach { horizontalStackView.addArrangedSubview($0) }
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            horizontalStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.2)
        ])
        NSLayoutConstraint.activate([
            confirmButton.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.6)
        ])
    }
}
