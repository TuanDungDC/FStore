//
//  ProductReviewTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit

class ProductReviewTableViewCell: ProductTableViewCell {
    
    var productReviewTableViewController: ProductReviewTableViewController?
    
    lazy var reviewButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Viết đánh giá", for: .normal)
        b.layer.cornerRadius = 4
        b.layer.borderColor = MAIN_COLOR.cgColor
        b.layer.borderWidth = 1
        b.clipsToBounds = true
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.setTitleColor(MAIN_COLOR, for: .normal)
        b.addTarget(self, action: #selector(handleShowReviewViewController), for: .touchUpInside)
        return b
    }()
    
    override func configureComponents() {
        configureProductImageView()
        configureNameLabel()
        
        contentView.addSubview(reviewButton)
        reviewButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        reviewButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
        reviewButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        reviewButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func handleShowReviewViewController() {
        if let thumbnailUrl = product?.thumbnailUrl, let productName = product?.name, let productId = product?.id, let orderId = product?.orderId {
            productReviewTableViewController?.showReviewViewController(productImageUrl: thumbnailUrl, productName: productName, productId: productId, orderId: orderId)
        }
    }
}
