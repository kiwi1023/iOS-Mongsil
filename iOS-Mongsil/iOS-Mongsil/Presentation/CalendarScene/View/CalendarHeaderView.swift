//
//  CalendarHeaderView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit

protocol MonthViewDelegate: AnyObject {
    func didChangeMonth(monthIndex: Int, year: Int)
}

final class CalendarHeaderView: SuperViewSetting {
    private let monthsArray = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    private let daysArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private var currentMonthIndex = 0
    private var currentYear: Int = 0
    weak var delegate: MonthViewDelegate?
    
    override func setupDefault() {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        dateLabel.text = "\(currentYear)년 \(monthsArray[currentMonthIndex]) "
        rightButton.addTarget(self, action: #selector(changeMonth(sender:)), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(changeMonth(sender:)), for: .touchUpInside)
    }
    
    override func addUIComponents() {
        addSubview(dateStackView)
        addSubview(weekdayStackView)
        [leftButton, dateLabel, rightButton].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        for index in 0..<7 {
            let label = UILabel()
            label.text = daysArray[index]
            label.font = UIFont(name: "GamjaFlower-Regular", size: 15)
            label.textAlignment = .center
            weekdayStackView.addArrangedSubview(label)
        }
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 90),
            dateStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -90)
        ])
        
        NSLayoutConstraint.activate([
            weekdayStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 20),
            weekdayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weekdayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            weekdayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20)
        ])
    }
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Month Year text"
        label.textAlignment = .center
        label.font = UIFont(name: "GamjaFlower-Regular", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward",
                                withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 20, right: 17)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward",
                                withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), for: .normal)
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 20, right: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc
    private func changeMonth(sender: UIButton) {
        if sender == rightButton {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else if sender == leftButton {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        
        dateLabel.text="\(currentYear)년 \(monthsArray[currentMonthIndex]) "
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
}

