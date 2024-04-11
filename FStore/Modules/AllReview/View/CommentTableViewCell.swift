//
//  AllReviewTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell {
    
    var comment: CommentResponse? {
        didSet {
            if let rating = comment?.rating {
                if rating == 1 {
                    titleLabel.text = "Rất không hài lòng"
                }
                if rating == 2 {
                    titleLabel.text = "Không hài lòng"
                }
                if rating == 3 {
                    titleLabel.text = "Bình thường"
                }
                if rating == 4 {
                    titleLabel.text = "Hài lòng"
                }
                if rating == 5 {
                    titleLabel.text = "Cực kì hài lòng"
                }
                ratingView.rating = Double(rating)
            }
            if let commentText = comment?.commentText {
                commentLabel.text = commentText
            }
            if let userName = comment?.userName {
                usernameLabel.text = userName
            }
            if let createAt = comment?.createAt {
                let date = Date()
                let dateFormatter = date.getFormattedDate(string: createAt)
                dateLabel.text = dateFormatter
            }
        }
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .darkGray
        l.textAlignment = .right
        return l
    }()
    
    let ratingView: CosmosView = {
        let v = CosmosView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.settings.updateOnTouch = false
        v.settings.starSize = 12
        v.settings.starMargin = 2
        v.settings.totalStars = 5
        v.settings.filledImage = #imageLiteral(resourceName: "gold-star")
        v.settings.emptyImage = #imageLiteral(resourceName: "darkgray-star")
        v.settings.fillMode = StarFillMode.half
        v.rating = 0
        return v
    }()
    
    let usernameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .darkGray
        return l
    }()
    
    let commentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -94).isActive = true // 86 = 70 (dateLabel width) + 16 (rightAnchor) + 8 (space between titleLabel and dateLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        contentView.addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        ratingView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        contentView.addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        contentView.addSubview(commentLabel)
        commentLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: ratingView.leftAnchor).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}
