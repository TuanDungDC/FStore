//
//  RatedProductTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Cosmos

class RatedProductTableViewCell: UITableViewCell {
    
    var product: RatedProductResponse? {
        didSet {
            if let thumbnailUrl = product?.thumbnailUrl {
                productImageView.sd_setImage(with: URL(string: thumbnailUrl)!, placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
            }
            if let rating = product?.rating {
                ratingView.rating = Double(rating)
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
            }
            if let comment = product?.comment {
                commentTextLabel.text = comment
            }
            if let status = product?.status {
                if status == 0 {
                    statusLabel.text = "Đang chờ duyệt"
                }
                if status == 1 {
                    statusLabel.text = "Đã duyệt"
                }
            }
        }
    }
    
    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    let ratingView: CosmosView = {
        let v = CosmosView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.settings.updateOnTouch = false
        v.settings.starSize = 13
        v.settings.starMargin = 2
        v.settings.totalStars = 5
        v.settings.filledImage = #imageLiteral(resourceName: "gold-star")
        v.settings.emptyImage = #imageLiteral(resourceName: "darkgray-star")
        v.rating = 0
        return v
    }()
    
    let commentTextLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(ratingView)
        ratingView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 73).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        contentView.addSubview(commentTextLabel)
        commentTextLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8).isActive = true
        commentTextLabel.leftAnchor.constraint(equalTo: ratingView.leftAnchor).isActive = true
        commentTextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: commentTextLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: commentTextLabel.leftAnchor).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}
