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
    weak var delegate: DatePickerViewContollerDelegate?
    private let datePickerView = DatePickerView()
    
    override func setupDefault() {
        view.backgroundColor = UIColor(named: "closeButtonColor")
        datePickerView.delegate = self
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
