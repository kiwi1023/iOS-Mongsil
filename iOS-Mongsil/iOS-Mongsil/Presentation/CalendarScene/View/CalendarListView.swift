//
//  CalendarListView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/16.
//

import UIKit

final class CalendarListView: SuperViewSetting {
    private let monthsArray = ["January", "Faburary", "March"
                               , "April", "May", "June", "July",
                               "August", "September", "October",
                               "November", "December"]
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    private var todaysDate = 0
    private var commentsCount = 0
    private let calendarListCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: UICollectionViewFlowLayout())
    var didTapcell: (([Int], BackgroundImage) -> ())?
    var loadCommentsCount: (([Int]) -> ())?
    var backgroundImages: [BackgroundImage] = [] {
        didSet {
            calendarListCollectionView.reloadData()
        }
    }
   
    func getCommentsCount(count: Int) {
        self.commentsCount = count
    }
    
    override func setupDefault() {
        configurationCollectionView()
        setupCalendarData()
        setNotification()
    }
    
    private func configurationCollectionView() {
        calendarListCollectionView.dataSource = self
        calendarListCollectionView.delegate = self
        calendarListCollectionView.register(CalendarListViewCell.self, forCellWithReuseIdentifier: "ListCell")
        calendarListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarListCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func setupCalendarData() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex - 1] = 29
        }
    }
    
    override func addUIComponents() {
        addSubview(calendarListCollectionView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            calendarListCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            calendarListCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            calendarListCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            calendarListCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: Notification.Name("Reload"),
            object: nil
        )
    }
    
    @objc
    private func reload() {
        calendarListCollectionView.reloadData()
    }
}

extension CalendarListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                      for: indexPath) as! CalendarListViewCell
        var year = currentYear
        var day = todaysDate - indexPath.item
        var month = currentMonthIndex - 1
        
        while day < 1 {
            let previousMonth = month < 2 ? 11 : month - 1
            day += numOfDaysInMonth[previousMonth]
            month = previousMonth
            let previousYear = currentMonthIndex < 2 ? currentYear - 1 : currentYear
            year = previousYear
        }
        
        loadCommentsCount?([year, month + 1, day])
        cell.configure(data: backgroundImages[indexPath.row],
                       count: commentsCount,
                       year: year,
                       month:  monthsArray[month], day: day)
        
        return cell
    }
    
}

extension CalendarListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.calendarListCollectionView.bounds.width
        let height = self.calendarListCollectionView.bounds.height * 0.5
        let itemSize = CGSize(width: width, height: height)
        
        return itemSize
    }
}

extension CalendarListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var year = currentYear
        var day = todaysDate - indexPath.item
        var month = currentMonthIndex - 1
        
        while day < 1 {
            let previousMonth = month < 2 ? 11 : month - 1
            day += numOfDaysInMonth[previousMonth]
            month = previousMonth
            let previousYear = currentMonthIndex < 2 ? currentYear - 1 : currentYear
            year = previousYear
        }
        didTapcell?([year, month + 1, day], backgroundImages[indexPath.item])
    }
}
