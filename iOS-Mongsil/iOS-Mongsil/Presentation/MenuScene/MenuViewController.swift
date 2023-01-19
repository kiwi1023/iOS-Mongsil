//
//  MenuViewController.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/13.
//

import UIKit
import Combine
import Photos

protocol MenuViewControllerDelegate: AnyObject {
    func didTapIsShowCommentsButton()
}

final class MenuViewController: SuperViewControllerSetting {
    private let menuView = MenuView()
    private let viewModel: MenuViewModel
    private let input = PassthroughSubject<MenuViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let isHiddenComments: Bool
    private var backgroundImage: UIImage?
    weak var delegate: MenuViewControllerDelegate?
    
    init(date: Date, image: BackgroundImage, isHiddenComments: Bool) {
        self.viewModel = MenuViewModel(date: date, image: image)
        self.isHiddenComments = isHiddenComments
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.viewDidLoad)
    }
    
    override func setupDefault() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bindViewModel()
        setupTapGesture()
        setupMenuView()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .postBackgroundURL(let url):
                self.fetchBackgroundImage(url: url)
            case .postIsScrappedBackgorund(let result):
                self.setupScrapButton(isScrappedBackground: result)
            case .dataBaseFailure(_):
                break
            }
        }.store(in: &cancellables)
    }
    
    private func fetchBackgroundImage(url: URL) {
        ImageCacheManager.shared.load(url: url)
            .sink { completion in
                switch completion {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                
                let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                self.backgroundImage = image?.resizeImageTo(size: size)
            }.store(in: &cancellables)
    }
    
    private func setupScrapButton(isScrappedBackground: Bool) {
        menuView.setupIsScrappedBackground(isScrappedBackground)
        menuView.setIsScrappedCommentItems()
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupMenuView() {
        menuView.delegate = self
        menuView.setupIsHiddenComments(isHiddenComments)
    }
    
    override func addUIComponents() {
        view.addSubview(menuView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            menuView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }
}

extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: menuView) == false else { return false }
        
        dismiss(animated: true)
        
        return true
    }
}

extension MenuViewController: MenuViewDelegate {
    func didTapIsShowCommentsButton() {
        delegate?.didTapIsShowCommentsButton()
    }
    
    func didTapShareButton() {
        let activityViewController = UIActivityViewController(activityItems: [backgroundImage as Any],
                                                              applicationActivities: nil)
        activityViewController.title = "공유"
        activityViewController.modalPresentationStyle = .fullScreen
        present(activityViewController, animated: true)
    }
    
    func didTapScrapImageButton() {
        input.send(.didTapScrappedButton)
    }
    
    func didTapDownloadImageButton() {
        downloadBackgroundImage()
    }
    
    private func downloadBackgroundImage() {
        guard let image = backgroundImage else { return }
        
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .authorized:
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.alertSavedImage), nil)
            case .denied:
                DispatchQueue.main.sync {
                    self.alertPermissionDenied()
                }
            case .restricted, .notDetermined:
                break
            default:
                break
            }
        })
    }
    
    @objc
    private func alertSavedImage(image: UIImage,
                                 didFinishSavingWithError error: Error?,
                                 contextInfo: UnsafeMutableRawPointer?) {
        guard error == nil else { return }
        
        let alertController = UIAlertController(title: "완료", message: "이미지가 갤러리에 저장되었습니다.",
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "확인", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func alertPermissionDenied() {
        let alertController = UIAlertController(title: "실패", message: "설정앱에서 권한을 허용해주세요.",
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "확인", style: .cancel))
        present(alertController, animated: true)
    }
}


