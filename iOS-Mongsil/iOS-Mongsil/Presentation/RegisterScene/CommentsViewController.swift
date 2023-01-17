//
//  RegisterViewController.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/08.
//

import UIKit
import Combine

final class CommentsViewController: SuperViewControllerSetting {
    private let viewModel: CommentsViewModel
    private let input = PassthroughSubject<CommentsViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let commentsView = CommentsView()
    private let commentInputView = CommentInputView()
    private var isShowKeyboard = false
    private lazy var inputTextViewMaxHeight = commentInputView.commentTextViewMaxHeight()
    
    init(date: Date, image: BackgroundImage) {
        self.viewModel = CommentsViewModel(date: date, image: image)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewWillAppear)
    }
    
    override func setupDefault() {
        bindViewModel()
        setupGradient()
        setupKeyboardNotifications()
        setupTapGesture()
        commentsView.setupDelegates(self)
        commentInputView.setupDelegates(self)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .postBackgroundURL(let url):
                self.setupBackGroundImage(url: url)
            case .fetchDataSuccess(_):
                self.commentsView.reloadTableView()
                self.commentsView.scrollToRowTableView(self.viewModel.comments.count)
            case .postCurrentEmoticon(let emoticon):
                self.commentInputView.setupEmoticonImageView(emoticon)
            case .dataBaseFailure(let error):
                print(error)
            }
        }.store(in: &cancellables)
    }
    
    private func setupBackGroundImage(url: URL) {
        ImageCacheManager.shared.load(url: url)
            .sink { _ in
            } receiveValue: { [weak self] image in
                guard let self = self,
                      let image = image else { return }
                
                let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                self.view.backgroundColor = UIColor(patternImage: image.resizeImageTo(size: size))
            }.store(in: &cancellables)
    }
    
    private func setupGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0 , green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0 , green: 0, blue: 0, alpha: 0.9).cgColor,
            UIColor(red: 0 , green: 0, blue: 0, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.35, 1.0]
        view.layer.addSublayer(gradientLayer)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
            self?.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height + 4))
        })
        
        isShowKeyboard = true
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        view.transform = .identity
        isShowKeyboard = false
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func addUIComponents() {
        view.addSubview(commentsView)
        view.addSubview(commentInputView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate(
            [
                commentsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: 8),
                commentsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -8),
                commentsView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor, constant: -4),
                commentsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ])
        NSLayoutConstraint.activate(
            [
                commentInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                          constant: 8),
                commentInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                           constant: -8),
                commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell",
                                                       for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapCellEmoticon))
        cell.setupItems(comment: viewModel.comments[indexPath.row])
        cell.setupEmoticonTapGestureRecognizer(recognizer)
        
        return cell
    }
    
    @objc
    private func didTapCellEmoticon(sender : UITapGestureRecognizer) {
        let tapLocation = sender.location(in: commentsView.tableView)
        let indexPath = commentsView.tableView.indexPathForRow(at: tapLocation)
        let viewController = EmoticonsViewController(viewModelDelegate: viewModel.self,
                                                     indexPath: indexPath)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateSwipeAction = UIContextualAction(style: .normal,
                                                   title: "편집",
                                                   handler: { [weak self] _, _, completionHaldler in
            guard let self = self else { return }
            
            self.showCommentTextUpdateAlert(indexPath)
            completionHaldler(false)
        })
        let deleteSwipeAction = UIContextualAction(style: .normal,
                                                   title: "삭제",
                                                   handler: { [weak self] _, _, completionHaldler in
            guard let self = self else { return }
            
            self.input.send(.didTapDeleteCommentButton(self.viewModel.comments[indexPath.row].id))
            completionHaldler(false)
        })
        updateSwipeAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        deleteSwipeAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        let configuration = UISwipeActionsConfiguration(actions: [updateSwipeAction, deleteSwipeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    private func showCommentTextUpdateAlert(_ indexPath: IndexPath) {
        let comment = viewModel.comments[indexPath.row]
        let alertController = UIAlertController(title: "편집할 내용을 입력하세요", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.first?.text = comment.text
        alertController.textFields?.first?.font = UIFont(name: "GamjaFlower-Regular", size: 18.0)
        let updateAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self,
                  let text = alertController.textFields?.first?.text else { return }
            
            self.input.send(.didTapUpdateCommentButton(indexPath.row, text, comment.emoticon))
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension CommentsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let isMaxHeight = estimatedSize.height >= inputTextViewMaxHeight
        
        if isMaxHeight {
            textView.isScrollEnabled = true
            
            if textView.frame.height < inputTextViewMaxHeight {
                if let lastConstraint = textView.constraints.last, lastConstraint.firstAttribute == .height {
                    textView.removeConstraint(lastConstraint)
                    textView.heightAnchor.constraint(equalToConstant: inputTextViewMaxHeight).isActive = true
                }
            }
            
            textView.reloadInputViews()
            textView.setNeedsUpdateConstraints()
            
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "오늘의 기분을 입력해주세요." {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘의 기분을 입력해주세요."
        }
    }
}

extension CommentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: commentsView) == false,
              touch.view?.isDescendant(of: commentInputView) == false else { return false }
        guard isShowKeyboard == false else {
            view.endEditing(true)
            
            return true
        }
        
        presentMenuView()
        
        return true
    }
    
    private func presentMenuView() {
        let viewContoller = MenuViewController(date: viewModel.date,
                                               image: viewModel.image,
                                               isHiddenComments: commentsView.isHidden)
        viewContoller.modalPresentationStyle = .overFullScreen
        viewContoller.delegate = self
        present(viewContoller, animated: true)
    }
}

extension CommentsViewController: CommentInputViewDelegate {
    func didTapEmoticonButton() {
        let viewController = EmoticonsViewController(viewModelDelegate: viewModel.self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func didTapAddCommentButton(_ didTapAddCommentButton: String) {
        input.send(.didTapCreateCommentButton(didTapAddCommentButton))
    }
}

extension CommentsViewController: MenuViewControllerDelegate {
    func didTapIsShowCommentsButton() {
        commentsView.isHidden.toggle()
        commentInputView.isHidden.toggle()
    }
}

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
