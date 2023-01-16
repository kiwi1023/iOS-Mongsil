//
//  CommentsTableView.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/08.
//

import UIKit

final class CommentsView: SuperViewSetting {
    var tableView: UITableView {
        commentsTableView
    }
    
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init()
    }
    
    func setupDelegates(_ viewController: UIViewController) {
        commentsTableView.dataSource = viewController as? UITableViewDataSource
        commentsTableView.delegate = viewController as? UITableViewDelegate
    }
    
    func reloadTableView() {
        commentsTableView.reloadData()
    }
    
    func scrollToRowTableView(_ dataCount: Int) {
        DispatchQueue.main.async { [weak self] in
            guard dataCount > 1 else { return }
            
            self?.commentsTableView.scrollToRow(at: IndexPath(row: dataCount - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    override func setupDefault() {
        backgroundColor = UIColor.black.withAlphaComponent(0)
    }
    
    override func addUIComponents() {
        addSubview(commentsTableView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate(
            [
                commentsTableView.topAnchor.constraint(equalTo: topAnchor),
                commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                commentsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
