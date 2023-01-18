//
//  CalendarListViewCell.swift
//  iOS-Mongsil
//
//  Created by Kiwon Song on 2023/01/16.
//

import UIKit
import Combine

final class CalendarListViewCell: UICollectionViewCell {
    private var cancellables = Set<AnyCancellable>()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let yearMonthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Lato-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Lato-Bold", size: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Regular", size: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icComment")
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.tintColor = .white
        return imageView
    }()
    
    private let placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeHolder")
        imageView.translatesAutoresizingMaskIntoConstraints=false
        
        return imageView
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("CalendarListViewCell Initialize error")
    }
    
    override func prepareForReuse() {
        backgroundImageView.image = nil
        commentCountLabel.text = nil
        yearLabel.text = nil
        monthLabel.text = nil
        dayLabel.text = nil
        cancellables.removeAll()
    }
    
    func configure(data: BackgroundImage, count: Int, year: Int, month: String, day: Int) {
        guard let url = URL(string: data.squareImage) else { return }
        
        ImageCacheManager.shared.load(url: url).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] image in
            guard let self = self else { return }
            
            self.backgroundImageView.image = image
        }.store(in: &cancellables)
        self.commentCountLabel.text = "\(count)"
        self.yearLabel.text = "\(year)"
        self.monthLabel.text = month
        self.dayLabel.text = "\(day)"
    }
    
    private func addUIComponents() {
        addSubview(placeHolderImageView)
        addSubview(backgroundImageView)
        addSubview(dayLabel)
        addSubview(yearMonthStackView)
        addSubview(commentImageView)
        addSubview(commentCountLabel)
        [yearLabel, monthLabel].forEach {
            yearMonthStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -7)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            placeHolderImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            placeHolderImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            placeHolderImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -7)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.heightAnchor.constraint(equalToConstant: 40),
            dayLabel.widthAnchor.constraint(equalToConstant: 50),
            dayLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 14),
            dayLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            yearMonthStackView.heightAnchor.constraint(equalToConstant: 40),
            yearMonthStackView.widthAnchor.constraint(equalToConstant: 90),
            yearMonthStackView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
            yearMonthStackView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            commentCountLabel.heightAnchor.constraint(equalToConstant: 15),
            commentCountLabel.widthAnchor.constraint(equalToConstant: 30),
            commentCountLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -20),
            commentCountLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            commentImageView.heightAnchor.constraint(equalToConstant: 20),
            commentImageView.widthAnchor.constraint(equalToConstant: 20),
            commentImageView.trailingAnchor.constraint(equalTo: commentCountLabel.leadingAnchor),
            commentImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -31)
        ])
    }
}

