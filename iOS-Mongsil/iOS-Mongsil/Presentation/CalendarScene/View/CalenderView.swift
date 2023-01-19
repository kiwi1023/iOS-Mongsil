//
//  CalenderView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit

final class CalenderView: SuperViewSetting, MonthViewDelegate {
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    private var presentMonthIndex = 0
    private var presentYear = 0
    private var todaysDate = 0
    private var firstWeekDayOfMonth = 0
    private var emoticon: String?
    private let calendarHeaderView = CalendarHeaderView()
    var didTapcell: (([Int]) -> ())?
    var loadCellEmoticon: (([Int]) -> ())?
    
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    override func setupDefault() {
        translatesAutoresizingMaskIntoConstraints = false
        setupCalendarData()
        calendarHeaderView.delegate = self
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func addUIComponents() {
        addSubview(calendarCollectionView)
        addSubview(calendarHeaderView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            calendarHeaderView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            calendarHeaderView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            calendarHeaderView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor),
            calendarCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 22.5),
            calendarCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -22.5),
            calendarCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCalendarData() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        firstWeekDayOfMonth = getFirstWeekDay()
        
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
    }
    
    private func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        calendarCollectionView.reloadData()
    }
    
    func reload() {
        calendarCollectionView.reloadData()
    }
    
    func getEmoticon(emoticon: String?) {
        self.emoticon = emoticon
    }
}

extension CalenderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarViewCell
        cell.todayImageView.isHidden = true
        cell.selectedStateImageView.isHidden = true
        setEmoticonImage(indexPath, cell)
        
        if indexPath.item + 1 == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
            cell.todayImageView.isHidden = false
        }
        
        distributeDay(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    private func setDayColor(day: Int, cell: CalendarViewCell) {
        if day % 7 == 6 {
            cell.dayLabel.textColor = UIColor(named: "saturdayColor")
        } else if day % 7 == 0 {
            cell.dayLabel.textColor =  UIColor(named: "sundayColor")
        } else {
            cell.dayLabel.textColor = UIColor(named: "weekdayColor")
        }
    }
    
    private func distributeDay(indexPath: IndexPath, cell: CalendarViewCell) {
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            let previousMonth = currentMonthIndex < 2 ? 12 : currentMonthIndex - 1
            let previousMonthDate = numOfDaysInMonth[previousMonth - 1]
            let date = previousMonthDate - (firstWeekDayOfMonth - 2) + indexPath.row
            setDayColor(day: indexPath.item, cell: cell)
            cell.dayLabel.text="\(date)"
            cell.dayLabel.alpha = 0.3
        } else if indexPath.item > numOfDaysInMonth[currentMonthIndex - 1] + (firstWeekDayOfMonth - 2) {
            let date = indexPath.item - numOfDaysInMonth[currentMonthIndex - 1] - (firstWeekDayOfMonth - 2)
            setDayColor(day: indexPath.item, cell: cell)
            cell.dayLabel.text = "\(date)"
            cell.dayLabel.alpha = 0.3
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            setDayColor(day: indexPath.item, cell: cell)
            cell.dayLabel.text = "\(calcDate)"
        }
    }
    
    private func setEmoticonImage(_ indexPath: IndexPath, _ cell: CalendarViewCell) {
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            let previousYear = currentMonthIndex < 2 ? currentYear - 1 : currentYear
            let previousMonth = currentMonthIndex < 2 ? 12 : currentMonthIndex - 1
            let previousMonthDate = numOfDaysInMonth[previousMonth - 1]
            let date = previousMonthDate - (firstWeekDayOfMonth - 2) + indexPath.row
            loadCellEmoticon?([previousYear, previousMonth, date])
            
            if let emoticon = emoticon {
                cell.emoticonImageView.image = UIImage(named: emoticon)
                cell.emoticonImageView.alpha = 0.3
                cell.dayLabel.isHidden = true
            }
        } else if indexPath.item > numOfDaysInMonth[currentMonthIndex - 1] + (firstWeekDayOfMonth - 2) {
            let date = indexPath.item - numOfDaysInMonth[currentMonthIndex - 1] - (firstWeekDayOfMonth - 2)
            let nextYear = currentMonthIndex == 12 ? currentYear + 1 : currentYear
            let nextMonth = currentMonthIndex == 12 ? 1 : currentMonthIndex + 1
            loadCellEmoticon?([nextYear, nextMonth, date])
            
            if let emoticon = emoticon {
                cell.emoticonImageView.image = UIImage(named: emoticon)
                cell.emoticonImageView.alpha = 0.3
                cell.dayLabel.isHidden = true
            }
        } else {
            loadCellEmoticon?([currentYear, currentMonthIndex, indexPath.item + 2 - (getFirstWeekDay())])
            
            if let emoticon = emoticon {
                cell.emoticonImageView.image = UIImage(named: emoticon)
            }
        }
    }
}

extension CalenderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 7
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

extension CalenderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewCell {
            cell.showIcon()
            
            if indexPath.item <= firstWeekDayOfMonth - 2 {
                let previousYear = currentMonthIndex < 2 ? currentYear - 1 : currentYear
                let previousMonth = currentMonthIndex < 2 ? 12 : currentMonthIndex - 1
                let previousMonthDate = numOfDaysInMonth[previousMonth - 1]
                let date = previousMonthDate - (firstWeekDayOfMonth - 2) + indexPath.row
                didTapcell?([previousYear, previousMonth, date])
            } else if indexPath.item > numOfDaysInMonth[currentMonthIndex - 1] + (firstWeekDayOfMonth - 2) {
                let date = indexPath.item - numOfDaysInMonth[currentMonthIndex - 1] - (firstWeekDayOfMonth - 2)
                let nextYear = currentMonthIndex == 12 ? currentYear + 1 : currentYear
                let nextMonth = currentMonthIndex == 12 ? 1 : currentMonthIndex + 1
                didTapcell?([nextYear, nextMonth, date])
            } else {
                didTapcell?([currentYear, currentMonthIndex, indexPath.item + 2 - (getFirstWeekDay())])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewCell {
            cell.hideIcon()
        }
    }
}
