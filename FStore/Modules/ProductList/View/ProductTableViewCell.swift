//
//  ProductTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Cosmos

class ProductTableViewCell: UITableViewCell {
    
    var product: ProductResponse? {
        didSet {
            
            if let name = product?.name {
                nameLabel.text = name
            }
            
            if let thumbnailUrl = product?.thumbnailUrl {
                productImageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
            }
            
            priceLabel.text = ""
            originPriceLabel.isHidden = true
            if product?.isSale == 1 {
                originPriceLabel.isHidden = false
                guard let price = product?.salePrice else { return }
                let priceFormatter = price.numberFormatter()
                guard let originPrice = product?.price else { return }
                let originPriceFormatter = originPrice.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.attributedText = (originPriceFormatter + " ₫").strikeThrough()
            }
            else {
                guard let price = product?.price else { return }
                let priceFormatter = price.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.isHidden = true
            }
            
            setupRatingView()
            
            totalCommentLabel.isHidden = true
            if let comment = product?.comment {
                if comment > 0 {
                    totalCommentLabel.isHidden = false
                    totalCommentLabel.text = "(\(comment))"
                }
            }
            
        }
    }
    
    func setupRatingView() {
        ratingView.isHidden = true
        if let rating = product?.rating {
            ratingView.isHidden = false
            ratingView.rating = Double(rating)
            
            if product?.isSale == 1 {
                ratingViewTopConstraint.constant = 26
            }
            else {
                ratingViewTopConstraint.constant = 8
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
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .darkGray
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureComponents() {
        configureProductImageView()
        configureNameLabel()
        configurePriceLabel()
        configureOriginPriceLabel()
        configureRatingView()
        configureTotalCommentLabel()
    }
    
    func configureProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor, constant: -10).isActive = true
    }
    
    func configureNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func configureOriginPriceLabel() {
        contentView.addSubview(originPriceLabel)
        originPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
        originPriceLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        originPriceLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    var ratingViewTopConstraint: NSLayoutConstraint!
    
    func configureRatingView() {
        contentView.addSubview(ratingView)
        ratingView.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 73).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        ratingViewTopConstraint = NSLayoutConstraint(item: ratingView, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .bottom, multiplier: 1, constant: 8)
        addConstraint(ratingViewTopConstraint!)
    }
    
    func configureTotalCommentLabel() {
        contentView.addSubview(totalCommentLabel)
        totalCommentLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        totalCommentLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 4).isActive = true
        totalCommentLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }
}
