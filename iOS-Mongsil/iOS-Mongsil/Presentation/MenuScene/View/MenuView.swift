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
    private enum MenuViewNameSpace {
        static let commentViewOffImage = "icViewOff"
        static let commentsLabelText = "일기 보이기"
        static let fontText = "GamjaFlower-Regular"
        static let shareImage = "icShare"
        static let shareLabelText = "공유"
        static let likeImage = "icLike"
        static let scrapImageLabelText = "스크랩"
        static let downloadImage = "icDownload"
        static let downloadLabelText = "저장"
        static let hideCommentsLabelText = "일기 숨기기"
        static let commentViewOnImage = "icViewOn"
        static let selectedLikeImage = "icLikeSel"
    }
    
    private var isHiddenComments = false
    private var isScrappedBackground = false
    weak var delegate: MenuViewDelegate?
    
    private let isShowCommentsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: MenuViewNameSpace.commentViewOffImage), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let isShowCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = MenuViewNameSpace.commentsLabelText
        label.font = UIFont(name: MenuViewNameSpace.fontText, size: 18.0)
        
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: MenuViewNameSpace.shareImage), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = MenuViewNameSpace.shareLabelText
        label.font = UIFont(name: MenuViewNameSpace.fontText, size: 18.0)
        
        return label
    }()
    
    private let scrapImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: MenuViewNameSpace.likeImage), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        button.tintColor = .black
        
        return button
    }()
    
    private let scrapImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = MenuViewNameSpace.scrapImageLabelText
        label.font = UIFont(name: MenuViewNameSpace.fontText, size: 18.0)
        
        return label
    }()
    
    private let downloadImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: MenuViewNameSpace.downloadImage), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let downloadImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = MenuViewNameSpace.downloadLabelText
        label.font = UIFont(name: MenuViewNameSpace.fontText, size: 18.0)
        
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
        isHiddenComments ? setupIsShowCommentsButtonImageViewOff() : setupIsShowCommentsButtonImageViewOn()
        isShowCommentsLabel.text = isHiddenComments ? MenuViewNameSpace.commentsLabelText : MenuViewNameSpace.hideCommentsLabelText
    }
    
    private func setupIsShowCommentsButtonImageViewOn() {
        isShowCommentsButton.setImage(UIImage(named: MenuViewNameSpace.commentViewOnImage), for: .normal)
    }
    
    private func setupIsShowCommentsButtonImageViewOff() {
        isShowCommentsButton.setImage(UIImage(named: MenuViewNameSpace.commentViewOffImage), for: .normal)
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
        scrapImageButton.setImage(UIImage(named: MenuViewNameSpace.selectedLikeImage), for: .normal)
    }
    
    private func setupscrapImageButtonImageLike() {
        scrapImageButton.setImage(UIImage(named: MenuViewNameSpace.likeImage), for: .normal)
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
