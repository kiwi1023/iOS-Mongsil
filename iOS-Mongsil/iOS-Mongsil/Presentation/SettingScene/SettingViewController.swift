//
//  ViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit
import MessageUI
import AuthenticationServices
import FirebaseAuth

final class SettingViewController: SuperViewControllerSetting, AlertProtocol, MFMailComposeViewControllerDelegate {
    private enum SettingViewControllerNameSpace {
        static let fontText = "GamjaFlower-Regular"
        static let weekdayColor = "weekdayColor"
        static let setting = "설정"
        static let backUpNotiMessage = "백업 및 복원 기능을 사용하려면 애플아이디 로그인이 필요합니다. 그래도 진행하시겠습니까?"
        static let notification = "알림"
        static let appStoreUrl = "https://apps.apple.com/app/id1666528737"
        static let action = "action"
        static let writeReview = "write-review"
        static let email = "mongsil.ios.help@gmail.com"
        static let composeViewText = "문의 및 의견"
        static let currentVersion = "CFBundleShortVersionString"
        static let mailFailure = "메일 전송 실패"
        static let mailFailureNotiMessage = "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요."
        static let appstore = "App Store로 이동하기"
        static let mailUrl = "https://apps.apple.com/kr/app/mail/id1108187098"
        static let cancelText = "취소"
    }
    
    let settingView = SettingView()
    
    override func setupDefault() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: SettingViewControllerNameSpace.fontText, size: 23)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: SettingViewControllerNameSpace.weekdayColor) as Any
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "설정"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        settingView.didTapFirstCell = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.pushViewController(PasswordSettingViewController(), animated: true)
        }
        settingView.didTapSecondCell = { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.pushViewController(NotificationViewController(), animated: true)
        }
        settingView.didTapThirdCell = { [weak self] in
            guard let self = self else { return }
            
            self.presentLoginPage()
        }
        settingView.didTapFourthCell = { [weak self] in
            guard let self = self else { return }
            
            self.presentReviewPage()
        }
        settingView.didTapFifthCell = { [weak self] in
            guard let self = self else { return }
            
            if MFMailComposeViewController.canSendMail() {
                self.presentMailView()
            } else {
                self.presentErrorAlert()
            }
        }
    }
    
    private func showLoginView() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(BackUpSettingViewController(), animated: true)
        }
        DispatchQueue.main.async { [weak self] in
            let loginView = LoginViewController()
            loginView.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self?.present(loginView, animated: true)
        }
    }
    
    private func presentLoginPage() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeyChainManger.shared.readKeyChain(dataType: .userIdentifier) ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(BackUpSettingViewController(), animated: true)
                }
            case .revoked, .notFound:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.present(self.makeCancellableConformAlert(titleText: SettingViewControllerNameSpace.notification, massageText: SettingViewControllerNameSpace.backUpNotiMessage, okAction: { [weak self] _ in
                        self?.showLoginView()
                    }), animated: true)
                }
            default:
                break
            }
        }
    }
    
    private func presentReviewPage() {
        if let appstoreURL = URL(string: SettingViewControllerNameSpace.appStoreUrl) {
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
                URLQueryItem(name: SettingViewControllerNameSpace.action, value: SettingViewControllerNameSpace.writeReview)
            ]
            guard let writeReviewURL = components?.url else {
                return
            }
            
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
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
        composeViewController.setToRecipients([SettingViewControllerNameSpace.email])
        composeViewController.setSubject(SettingViewControllerNameSpace.composeViewText)
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
              let version = dictionary[SettingViewControllerNameSpace.currentVersion] as? String else { return "" }
        
        return version
    }
    
    private func presentErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: SettingViewControllerNameSpace.mailFailure,
                                                   message: SettingViewControllerNameSpace.mailFailureNotiMessage,
                                                   preferredStyle: .alert)
        let goAppStoreAction = UIAlertAction(title: SettingViewControllerNameSpace.appstore, style: .default) { _ in
            if let url = URL(string: SettingViewControllerNameSpace.mailUrl),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancleAction = UIAlertAction(title: SettingViewControllerNameSpace.cancelText, style: .destructive, handler: nil)
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
