//
//  AlertProtocol.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/24.
//

import UIKit

private enum AlertProtocolNameSpace {
    static let alertFont = "GamjaFlower-Regular"
    static let alertTitleKeyValue = "attributedTitle"
    static let alertMessageKeyValue = "attributedMessage"
    static let okMessage = "확인"
    static let cancelMessage = "취소"
}

protocol AlertProtocol {
    func makeConformAlert(titleText: String, massageText: String?) -> UIAlertController
    func makeCancellableConformAlert(titleText: String,
                                     massageText: String?,
                                     okAction: @escaping (UIAlertAction) -> Void) -> UIAlertController
}

extension AlertProtocol {
    func makeConformAlert(titleText: String = "", massageText: String?) -> UIAlertController {
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: AlertProtocolNameSpace.alertFont, size: 23)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleStiring = NSAttributedString(string: titleText, attributes: titleAttributes)
        let massageAttributes = [NSAttributedString.Key.font: UIFont(name: AlertProtocolNameSpace.alertFont, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let massageString = NSAttributedString(string: massageText ?? "", attributes: massageAttributes)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleStiring, forKey: AlertProtocolNameSpace.alertTitleKeyValue)
        alertController.setValue(massageString, forKey: AlertProtocolNameSpace.alertMessageKeyValue)
        let okAction = UIAlertAction(title: AlertProtocolNameSpace.okMessage, style: .default) { _ in }
        alertController.addAction(okAction)
         
        return alertController
    }
    
    func makeCancellableConformAlert(titleText: String = "", massageText: String?, okAction: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: AlertProtocolNameSpace.alertFont, size: 23)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleStiring = NSAttributedString(string: titleText, attributes: titleAttributes)
        let massageAttributes = [NSAttributedString.Key.font: UIFont(name: AlertProtocolNameSpace.alertFont, size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let massageString = NSAttributedString(string: massageText ?? "", attributes: massageAttributes)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleStiring, forKey: AlertProtocolNameSpace.alertTitleKeyValue)
        alertController.setValue(massageString, forKey: AlertProtocolNameSpace.alertMessageKeyValue)
        let okAction = UIAlertAction(title: AlertProtocolNameSpace.okMessage, style: .default, handler: okAction)
        let cancelAction = UIAlertAction(title: AlertProtocolNameSpace.cancelMessage, style: .destructive)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
