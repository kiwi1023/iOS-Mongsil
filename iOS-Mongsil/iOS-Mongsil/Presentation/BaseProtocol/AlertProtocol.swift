//
//  AlertProtocol.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/24.
//

import UIKit

protocol AlertProtocol {
    func makeConformAlert(titleText: String, massageText: String?) -> UIAlertController
}

extension AlertProtocol {
    func makeConformAlert(titleText: String = "", massageText: String?) -> UIAlertController {
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleStiring = NSAttributedString(string: titleText, attributes: titleAttributes)
        let massageAttributes = [NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let massageString = NSAttributedString(string: massageText ?? "", attributes: massageAttributes)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleStiring, forKey: "attributedTitle")
        alertController.setValue(massageString, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in }
        alertController.addAction(okAction)
         
        return alertController
    }
}
