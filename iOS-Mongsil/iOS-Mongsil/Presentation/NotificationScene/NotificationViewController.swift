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
        
        if isSelectedTime == true {
            present(makeConformAlert(massageText: "알림이 설정되었습니다."), animated: true)
        }
    }
    
    override func setupDefault() {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "GamjaFlower-Regular", size: 23) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor(named: "weekdayColor") as Any
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = "알림 설정"
        notificationView.setupIsOnNotification(isOnNotification)
        notificationView.delegate = self
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
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print(error)
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
    
    func didTapChevronButton() {
        let viewController = DatePickerViewContoller()
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension NotificationViewController: DatePickerViewContollerDelegate {
    func didTapConfirmButton(dateComponents: DateComponents) {
        selectedDateComponents = dateComponents
        registerNotifocation()
    }
}
