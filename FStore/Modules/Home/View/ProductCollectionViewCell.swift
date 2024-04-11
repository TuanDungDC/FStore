//
//  ProductCollectionViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Cosmos

class ProductCollectionViewCell: UICollectionViewCell {
    
    var productResponse: ProductResponse? {
        didSet {

            if let name = productResponse?.name {
                nameLabel.text = name
            }

            if let thumbnailUrl = productResponse?.thumbnailUrl {
                guard let url = URL(string: thumbnailUrl) else { return }
                imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
            }

            priceLabel.text = ""
            originPriceLabel.isHidden = true
            if productResponse?.isSale == 1 {
                originPriceLabel.isHidden = false
                guard let price = productResponse?.salePrice else { return }
                let priceFormatter = price.numberFormatter()
                guard let originPrice = productResponse?.price else { return }
                let originPriceFormatter = originPrice.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.attributedText = (originPriceFormatter + " ₫").strikeThrough()
            }
            else {
                guard let price = productResponse?.price else { return }
                let priceFormatter = price.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.isHidden = true
            }

            ratingView.isHidden = true
            if let rating = productResponse?.rating {
                ratingView.isHidden = false
                ratingView.rating = Double(rating)
                
                if productResponse?.isSale == 1 {
                    ratingViewTopConstraint.constant = 26
                }
                else {
                    ratingViewTopConstraint.constant = 8
                }
            }

            totalCommentLabel.isHidden = true
            if let comment = productResponse?.comment {
                if comment > 0 {
                    totalCommentLabel.isHidden = false
                    totalCommentLabel.text = "(\(comment))"
                }
            }

        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 2
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        return l
    }()
    
    let originPriceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 14)
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
        v.settings.fillMode = StarFillMode.half
        v.rating = 0
        return v
    }()
    
    let totalCommentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .darkGray
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ratingViewTopConstraint: NSLayoutConstraint!
    
    func setupViews() {
        backgroundColor = .white
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        contentView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        contentView.addSubview(originPriceLabel)
        originPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
        originPriceLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        originPriceLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        addSubview(ratingView)
        ratingViewTopConstraint = NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .bottom, multiplier: 1, constant: 8)
        addConstraint(ratingViewTopConstraint!)
        ratingView.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(totalCommentLabel)
        totalCommentLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        totalCommentLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 4).isActive = true
        totalCommentLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
}
