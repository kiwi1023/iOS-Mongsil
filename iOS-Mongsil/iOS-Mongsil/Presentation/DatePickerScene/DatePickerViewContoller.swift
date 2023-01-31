//
//  DatePickerViewContoller.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit

protocol DatePickerViewContollerDelegate: AnyObject {
    func didTapConfirmButton(dateComponents: DateComponents)
}

final class DatePickerViewContoller: SuperViewControllerSetting {
    private enum DatePickerViewContollerNameSpace {
        static let closeButtonColor = "closeButtonColor"
    }
    
    private weak var delegate: DatePickerViewContollerDelegate?
    private var notificationTime: Date?
    private let datePickerView = DatePickerView()
    
    init(delegate: DatePickerViewContollerDelegate? = nil, selectedTime: Date? = nil) {
        self.delegate = delegate
        self.notificationTime = selectedTime
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupDefault() {
        view.backgroundColor = UIColor(named: DatePickerViewContollerNameSpace.closeButtonColor)
        datePickerView.delegate = self
        datePickerView.setupDatePicker(date: notificationTime)
    }

    override func addUIComponents() {
        view?.addSubview(datePickerView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            datePickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            datePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DatePickerViewContoller: DatePickerViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(components: DateComponents) {
        delegate?.didTapConfirmButton(dateComponents: components)
        dismiss(animated: true)
    }
}
