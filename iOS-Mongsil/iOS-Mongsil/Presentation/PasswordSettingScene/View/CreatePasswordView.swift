//
//  PasswordView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/18.
//

import UIKit

protocol CreatePasswordViewDelegate: AnyObject {
    func didTapCloseButton()
    func putWrongPassword()
    func putCorrectPassword(_ password: [Int])
}

class CreatePasswordView: SuperViewSetting {
    private var passwordCollectionView: UICollectionView! = nil
    private let passwordLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        
        return layout
    }()
    private let passwordHeader = PasswordHeaderView(frame: .zero, title: "새 암호를 입력해 주세요.")
    private var didTapFirstCellCount = 0
    private var didTapSecondCellCount = 0
    private var isFirstDataFinished = false
    private var firstPasswordData: [Int] = []
    private var secondPasswordData: [Int] = []
    weak var delegate: CreatePasswordViewDelegate?
    
    deinit {
        let password = KeyChainManger.shared.readKeyChain(dataType: .passWord)
        if password == nil,
           secondPasswordData.count != 4,
           UserDefaults.standard.bool(forKey: "toggleState") == true {
            NotificationCenter.default.post(name: Notification.Name("SwitchTurnOff"),
                                            object: self)
        }
    }
    
    override func setupDefault() {
        translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
        passwordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: passwordLayout)
        passwordCollectionView.translatesAutoresizingMaskIntoConstraints = false
        passwordCollectionView.delegate = self
        passwordCollectionView.dataSource = self
        passwordCollectionView.register(PasswordViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func addUIComponents() {
        addSubview(closeButton)
        addSubview(passwordCollectionView)
        addSubview(passwordHeader)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray
        
        return button
    }()
    
    @objc private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

extension CreatePasswordView: UICollectionViewDataSource {
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

extension CreatePasswordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.3
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}

extension CreatePasswordView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        distributeFirstPasswordData(indexPath)
        
        if isFirstDataFinished {
            distributeSecondPasswordData(indexPath)
        }
        
        if didTapFirstCellCount == 4 {
            passwordHeader.titleLabel.text = "한번 더 입력해 주세요."
            
            for index in 0...3 {
                passwordHeader.signImageViews[index].tintColor = UIColor(named: "passwordColor")
            }
            didTapFirstCellCount += 1
            isFirstDataFinished = true
        }
        
        if didTapSecondCellCount == 4 {
            firstPasswordData == secondPasswordData ? delegate?.putCorrectPassword(secondPasswordData) : resetPasswordData()
        }
    }
    
    private func distributeFirstPasswordData(_ indexPath: IndexPath) {
        if indexPath.item == 11 {
            guard didTapFirstCellCount != 5,
                  didTapFirstCellCount != 0 else { return }
            
            didTapFirstCellCount -= 1
            passwordHeader.signImageViews[didTapFirstCellCount].tintColor = UIColor(named: "passwordColor")
            firstPasswordData.removeLast()
        } else {
            guard didTapFirstCellCount != 5 else { return }
            
            passwordHeader.signImageViews[didTapFirstCellCount].tintColor = .black
            didTapFirstCellCount += 1
            
            if indexPath.item == 10 {
                firstPasswordData.append(0)
            } else {
                firstPasswordData.append(indexPath.item + 1)
            }
        }
    }
    
    private func distributeSecondPasswordData(_ indexPath: IndexPath) {
        if indexPath.item == 11 {
            guard didTapSecondCellCount != 0 else { return }
            
            didTapSecondCellCount -= 1
            passwordHeader.signImageViews[didTapSecondCellCount].tintColor = UIColor(named: "passwordColor")
            secondPasswordData.removeLast()
        } else {
            guard didTapSecondCellCount != 4 else { return }
            
            passwordHeader.signImageViews[didTapSecondCellCount].tintColor = .black
            didTapSecondCellCount += 1
            
            if indexPath.item == 10 {
                secondPasswordData.append(0)
            } else {
                secondPasswordData.append(indexPath.item + 1)
            }
        }
    }
    
    private func resetPasswordData() {
        delegate?.putWrongPassword()
        firstPasswordData.removeAll()
        secondPasswordData.removeAll()
        didTapFirstCellCount = 0
        didTapSecondCellCount = 0
        isFirstDataFinished = false
        passwordHeader.titleLabel.text = "새 암호를 입력해 주세요."
        
        for index in 0...3 {
            passwordHeader.signImageViews[index].tintColor = UIColor(named: "passwordColor")
        }
    }
}
