//
//  SettingView.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/17.
//

import UIKit

enum SettingViewTitleData: CaseIterable {
    case setPassword
    case setNotification
    case writeReview
    case writeInquiry
    
    var image: String {
        switch self {
        case .setPassword:
            return "icPassword"
        case .setNotification:
            return "icNotice"
        case .writeReview:
            return "icReview"
        case .writeInquiry:
            return "icQuestion"
        }
    }
    
    var title: String {
        switch self {
        case .setPassword:
            return "비밀번호 설정"
        case .setNotification:
            return "알림 설정"
        case .writeReview:
            return "리뷰쓰기"
        case .writeInquiry:
            return "문의하기"
        }
    }
    
    var needChavronImage: Bool {
        switch self {
        case .setPassword:
            return true
        case .setNotification:
            return true
        case .writeReview:
            return false
        case .writeInquiry:
            return false
        }
    }
}

final class SettingView: SuperViewSetting {
    private var settingCollectionView: UICollectionView! = nil
    private let settingLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        
        return layout
    }()
    
    override func setupDefault() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configurationCollectionView()
        settingCollectionView.delegate = self
        settingCollectionView.dataSource = self
        settingCollectionView.register(SettingViewCell.self, forCellWithReuseIdentifier: "SettingViewCell")
    }
    
    override func addUIComponents() {
        addSubview(settingCollectionView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            settingCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            settingCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            settingCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            settingCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configurationCollectionView() {
        settingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: settingLayout)
        settingCollectionView.backgroundColor = .systemBackground
        settingCollectionView.showsHorizontalScrollIndicator = false
        settingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        settingCollectionView.allowsMultipleSelection = false
    }
}

extension SettingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return SettingViewTitleData.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingViewCell", for: indexPath) as! SettingViewCell
        let settingData = SettingViewTitleData.allCases[indexPath.item]
        cell.configure(text: settingData.title, image: settingData.image, needChevronImage: settingData.needChavronImage)
        
        return cell
    }
}

extension SettingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.settingCollectionView.bounds.width
        let height = self.settingCollectionView.bounds.height * 0.05
        let itemSize = CGSize(width: width, height: height)
        
        return itemSize
    }
}

extension SettingView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
    }
}