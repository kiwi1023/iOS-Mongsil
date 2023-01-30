//
//  PasswordView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/19.
//

import UIKit

protocol PasswordViewDelegate: AnyObject {
    func putWrongPassword()
    func putCorrectPassword()
}

class PasswordView: SuperViewSetting {
    private var passwordCollectionView: UICollectionView! = nil
    private let passwordLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        
        return layout
    }()
    private let passwordHeader = PasswordHeaderView(frame: .zero, title: "암호를 입력해 주세요.")
    private var didTapCellCount = 0
    private var passwordData: [Int] = []
    weak var delegate: PasswordViewDelegate?
    
    override func setupDefault() {
        translatesAutoresizingMaskIntoConstraints = false
       
        passwordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: passwordLayout)
        passwordCollectionView.translatesAutoresizingMaskIntoConstraints = false
        passwordCollectionView.delegate = self
        passwordCollectionView.dataSource = self
        passwordCollectionView.register(PasswordViewCell.self, forCellWithReuseIdentifier: "Cell")
        passwordCollectionView.isScrollEnabled = false
    }
    
    override func addUIComponents() {
        addSubview(passwordCollectionView)
        addSubview(passwordHeader)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            passwordHeader.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            passwordHeader.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            passwordHeader.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            passwordCollectionView.topAnchor.constraint(equalTo: passwordHeader.bottomAnchor, constant: 30),
            passwordCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            passwordCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            passwordCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PasswordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PasswordViewCell
        
        if indexPath.item == 9 {
            cell.numberLabel.isHidden = true
        } else if indexPath.item == 10 {
            cell.numberLabel.text = "\(0)"
        } else if indexPath.item == 11 {
            cell.numberLabel.text = "삭제"
        } else {
            cell.numberLabel.text = "\(indexPath.item + 1)"
        }
        
        return cell
    }
}

extension PasswordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.3
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}

extension PasswordView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 11 {
            guard didTapCellCount != 0 else { return }
          
            didTapCellCount -= 1
            passwordHeader.signImageViews[didTapCellCount].tintColor = UIColor(named: "passwordColor")
            passwordData.removeLast()
        } else {
            passwordHeader.signImageViews[didTapCellCount].tintColor = .black
            didTapCellCount += 1
            
            if indexPath.item == 10 {
                passwordData.append(0)
            } else {
                passwordData.append(indexPath.item + 1)
            }
        }
        
        if didTapCellCount == 4 {
            let passwordString = passwordData.map(String.init).joined()
            passwordString == KeyChainManger.shared.readKeyChain(dataType: .passWord) ? delegate?.putCorrectPassword() : resetPasswordData()
        }
    }
    
    private func resetPasswordData() {
        delegate?.putWrongPassword()
        passwordData.removeAll()
        didTapCellCount = 0
       
        for index in 0...3 {
            passwordHeader.signImageViews[index].tintColor = UIColor(named: "passwordColor")
        }
    }
}
