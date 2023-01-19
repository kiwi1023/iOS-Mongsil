//
//  MenuView.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/13.
//

import UIKit

protocol MenuViewDelegate: NSObject {
    func didTapShareButton()
    func didTapScrapImageButton()
    func didTapDownloadImageButton()
    func didTapIsShowCommentsButton()
}

final class MenuView: SuperViewSetting {
    private var isHiddenComments = false
    private var isScrappedBackground = false
    weak var delegate: MenuViewDelegate?
    
    private let isShowCommentsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icViewOff"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let isShowCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "일기 숨기기"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icShare"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "공유"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        
        return label
    }()
    
    private let scrapImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icLike"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        button.tintColor = .black
        
        return button
    }()
    
    private let scrapImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "스크랩"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        
        return label
    }()
    
    private let downloadImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icDownload"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let downloadImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "저장"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        
        return label
    }()
    
    func setupIsHiddenComments(_ isHiddenComments: Bool) {
        self.isHiddenComments = isHiddenComments
        setIsShowCommentsItems()
    }
    
    func setupIsScrappedBackground(_ isScrappedBackground: Bool) {
        self.isScrappedBackground = isScrappedBackground
    }
    
    override func setupDefault() {
        isShowCommentsButton.addTarget(self, action: #selector(didTapIsShowCommentsButton), for: .touchDown)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchDown)
        scrapImageButton.addTarget(self, action: #selector(didTapScrapImageButton), for: .touchDown)
        downloadImageButton.addTarget(self, action: #selector(didTapDownloadImageButton), for: .touchDown)
    }
    
    @objc
    private func didTapIsShowCommentsButton() {
        delegate?.didTapIsShowCommentsButton()
        setIsShowCommentsItems()
    }
    
    private func setIsShowCommentsItems() {
        isHiddenComments.toggle()
        isHiddenComments ? setupIsShowCommentsButtonImageViewOn() : setupIsShowCommentsButtonImageViewOff()
        isShowCommentsLabel.text = isHiddenComments ? "일기 보이기" : "일기 숨기기"
    }
    
    private func setupIsShowCommentsButtonImageViewOn() {
        isShowCommentsButton.setImage(UIImage(named: "icViewOn"), for: .normal)
    }
    
    private func setupIsShowCommentsButtonImageViewOff() {
        isShowCommentsButton.setImage(UIImage(named: "icViewOff"), for: .normal)
    }
    
    @objc
    private func didTapShareButton() {
        delegate?.didTapShareButton()
    }
    
    @objc
    private func didTapScrapImageButton() {
        delegate?.didTapScrapImageButton()
        setIsScrappedCommentItems()
    }
    
    func setIsScrappedCommentItems() {
        isScrappedBackground ? setupscrapImageButtonImageLikeSel() : setupscrapImageButtonImageLike()
        isScrappedBackground.toggle()
    }
    
    private func setupscrapImageButtonImageLikeSel() {
        scrapImageButton.setImage(UIImage(named: "icLikeSel"), for: .normal)
    }
    
    private func setupscrapImageButtonImageLike() {
        scrapImageButton.setImage(UIImage(named: "icLike"), for: .normal)
    }
    
    @objc
    private func didTapDownloadImageButton() {
        delegate?.didTapDownloadImageButton()
    }
    
    override func addUIComponents() {
        addSubview(isShowCommentsButton)
        addSubview(isShowCommentsLabel)
        addSubview(shareButton)
        addSubview(shareLabel)
        addSubview(scrapImageButton)
        addSubview(scrapImageLabel)
        addSubview(downloadImageButton)
        addSubview(downloadImageLabel)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
                isShowCommentsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45),
                isShowCommentsButton.bottomAnchor.constraint(equalTo: isShowCommentsLabel.topAnchor),
                isShowCommentsButton.heightAnchor.constraint(equalToConstant: 30),
                isShowCommentsLabel.centerXAnchor.constraint(equalTo: isShowCommentsButton.centerXAnchor),
                isShowCommentsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
        NSLayoutConstraint.activate([
                shareButton.trailingAnchor.constraint(equalTo: scrapImageButton.leadingAnchor, constant: -25),
                shareButton.bottomAnchor.constraint(equalTo: shareLabel.topAnchor),
                shareButton.heightAnchor.constraint(equalToConstant: 30),
                shareLabel.centerXAnchor.constraint(equalTo: shareButton.centerXAnchor),
                shareLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
                
            ])
        NSLayoutConstraint.activate([
                scrapImageButton.trailingAnchor.constraint(equalTo: downloadImageButton.leadingAnchor, constant: -25),
                scrapImageButton.bottomAnchor.constraint(equalTo: scrapImageLabel.topAnchor),
                scrapImageButton.heightAnchor.constraint(equalToConstant: 30),
                scrapImageLabel.centerXAnchor.constraint(equalTo: scrapImageButton.centerXAnchor),
                scrapImageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
        NSLayoutConstraint.activate([
                downloadImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
                downloadImageButton.bottomAnchor.constraint(equalTo: downloadImageLabel.topAnchor),
                downloadImageButton.heightAnchor.constraint(equalToConstant: 30),
                downloadImageLabel.centerXAnchor.constraint(equalTo: downloadImageButton.centerXAnchor),
                downloadImageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
    }
}
