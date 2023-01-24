//
//  NotificationViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/17.
//

import UIKit
import UserNotifications

final class NotificationViewController: SuperViewControllerSetting, AlertProtocol {
    private let notificationView = NotificationView()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userDefault = UserDefaults.standard
    private var selectedDateComponents: DateComponents?
    private var isSelectedTime = false
    private var isOnNotification: Bool {
        get {
            userDefault.object(forKey: "isOnNotification") as? Bool ?? false
        }
        
        set {
            userDefault.set(newValue, forKey: "isOnNotification")
        }
    }
    private var notificationTime: Date? {
        get {
            userDefault.object(forKey: "notificationTime") as? Date
        }
        
        set {
            userDefault.set(newValue, forKey: "notificationTime")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentCurrentNotificationAuthorizationState()
    }
    
    private func presentCurrentNotificationAuthorizationState() {
        guard isSelectedTime == true else { return }
        
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            
            switch settings.alertSetting {
            case .enabled:
                DispatchQueue.main.async {
                    self.present(self.makeConformAlert(massageText: "알림이 설정되었습니다."), animated: true)
                }
            default:
                self.isOnNotification = false
                DispatchQueue.main.async {
                    self.present(self.makeConformAlert(massageText: "설정앱에서 권한을 설정해주세요."), animated: true)
                    self.notificationView.setupIsOnNotification(self.isOnNotification)
                }
            }
        }
    }
    
    override func setupDefault() {
        setupNavigation()
        notificationView.delegate = self
        notificationView.setupIsOnNotification(isOnNotification)
    }
    
    private func setupNavigation() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "알림 설정"
    }
    
    override func addUIComponents() {
        view?.addSubview(notificationView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            notificationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            notificationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            notificationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

extension NotificationViewController: NotificationViewDelegate {
    func didTapToggleButton() {
        if isOnNotification == true {
            isOnNotification = false
            notificationCenter.removeAllPendingNotificationRequests()
        } else if isOnNotification == false {
            isOnNotification = true
            requestNotificationAuthorization()
            registerNotifocation()
        }
        
        notificationView.setupIsOnNotification(isOnNotification)
    }
    
    private func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: authOptions) { [weak self] success, error in
            guard let self = self else { return }
            
            if success == false {
                self.isOnNotification = false
                DispatchQueue.main.async {
                    self.present(self.makeConformAlert(titleText: "실패", massageText: "설정앱에서 권한을 설정해주세요"),
                                 animated: true)
                    self.notificationView.setupIsOnNotification(self.isOnNotification)
                }
            }
        }
    }
    
    private func registerNotifocation() {
        guard let dateComponents = selectedDateComponents, isOnNotification == true else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "몽실"
        content.body = "오늘 하루 어떠셨나요? 오늘의 기분을 한번 기록해 볼까요?"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "Mosil", content: content, trigger: trigger)
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.add(request)
    }
    
    func didTapTimeSelectButton() {
        isSelectedTime = false
        let viewController = DatePickerViewContoller(delegate: self, selectedTime: notificationTime)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension NotificationViewController: DatePickerViewContollerDelegate {
    func didTapConfirmButton(dateComponents: DateComponents) {
        selectedDateComponents = dateComponents
        notificationTime = Calendar.current.date(from: dateComponents)
        registerNotifocation()
        isSelectedTime = true
    }
}
