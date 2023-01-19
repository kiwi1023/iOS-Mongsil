//
//  CommentTableViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/08.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let emoticonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemYellow
        label.font = UIFont(name: "NanumSeHwaCe", size: 20.0)
        
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "NanumSeHwaCe", size: 20.0)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("CommentTableViewCell Initialize error")
    }
    
    func setupItems(comment: Comment) {
        timeLabel.text = comment.date.convertKorean
        commentTextLabel.text = comment.text
        emoticonImageView.image = comment.emoticon.image
    }
    
    func setupEmoticonTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        emoticonImageView.addGestureRecognizer(recognizer)
        emoticonImageView.isUserInteractionEnabled = true
    }
    
    private func setupDefault() {
        backgroundColor = UIColor.green.withAlphaComponent(0)
    }
    
    private func addUIComponents() {
        contentView.addSubview(mainStackView)
        [emoticonImageView, verticalStackView].forEach { mainStackView.addArrangedSubview($0) }
        [timeLabel, commentTextLabel].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ])
        NSLayoutConstraint.activate([
                verticalStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.85)
            ])
    }
}
