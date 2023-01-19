//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit
import MessageUI

class SettingViewController: SuperViewControllerSetting, MFMailComposeViewControllerDelegate {
    let settingView = SettingView()
    
    override func setupDefault() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "설정"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        settingView.didTapFirstCell = {
            self.navigationController?.pushViewController(PassWordSettingViewController(), animated: true)
        }
        settingView.didTapSecondCell = {
            self.navigationController?.pushViewController(NotificationViewController(), animated: true)
        }
        settingView.didTapThirdCell = {
//            if let appstoreURL = URL(string: "https://apps.apple.com/app/id1522259532") {
//                var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
//                components?.queryItems = [
//                    URLQueryItem(name: "action", value: "write-review")
//                ]
//                guard let writeReviewURL = components?.url else {
//                    return
//                }
//
//                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
//            }
        }
        settingView.didTapFourthCell = { [weak self] in
            if MFMailComposeViewController.canSendMail() {
                self?.presentMailView()
            } else {
                self?.presentErrorAlert()
            }
        }
    }
    
    private func presentMailView() {
        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        let bodyString = """
        
        몽실에게 건의하기 :
        
        -------------------
        
        Device Model : \(self.getDeviceIdentifier())
        Device OS : \(UIDevice.current.systemVersion)
        App Version : \(self.getCurrentVersion())
        
        -------------------
        """
        composeViewController.setToRecipients(["mongsil.ios.help@gmail.com"])
        composeViewController.setSubject("문의 및 의견")
        composeViewController.setMessageBody(bodyString, isHTML: false)
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    private func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        
        return version
    }
    
    private func presentErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
                                                   message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
                                                   preferredStyle: .alert)
        let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
            if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        sendMailErrorAlert.addAction(goAppStoreAction)
        sendMailErrorAlert.addAction(cancleAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    override func addUIComponents() {
        view.addSubview(settingView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
