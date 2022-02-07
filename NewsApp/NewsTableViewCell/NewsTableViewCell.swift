//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Macbook on 05.02.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel = UILabel.getLabel(fontSize: 20,
                                                  fontWeight: .semibold,
                                                  textAligment: .center,
                                                  textColor: nil)
    
    private let subtitleTitleLabel = UILabel.getLabel(fontSize: 15,
                                                      fontWeight: .light,
                                                      textAligment: .left,
                                                      textColor: nil)
    
    private let numberOfClicksLabel = UILabel.getLabel(fontSize: 10,
                                                       fontWeight: .light,
                                                       textAligment: .right,
                                                       textColor: .systemGray)
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleTitleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(numberOfClicksLabel)
    }
    
    required init? (coder: NSCoder) {
        fatalError ()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleTitleLabel.text = nil
        newsImageView.image = nil
        numberOfClicksLabel.text = nil
    }
    
    func configure(with viewModel: NewsTableViewCellModel) {
        newsTitleLabel.text = viewModel.title
        subtitleTitleLabel.text = viewModel.subtitle
        numberOfClicksLabel.text = "Number of clicks: \(viewModel.clicksCount)"
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data:data)
        } else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data:data)
                }
            }.resume()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            newsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            newsImageView.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 10),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            newsImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            subtitleTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
            subtitleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            subtitleTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            subtitleTitleLabel.bottomAnchor.constraint(equalTo: numberOfClicksLabel.topAnchor, constant: 0),
            
            numberOfClicksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            numberOfClicksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            numberOfClicksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            numberOfClicksLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}

extension UILabel {
    static func getLabel(fontSize: CGFloat,
                         fontWeight: UIFont.Weight,
                         textAligment: NSTextAlignment,
                         textColor: UIColor?) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = textAligment
        label.textColor = textColor ?? .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
