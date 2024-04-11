//
//  OrderDetailTableViewCell6.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderDetailTableViewCell6: OrderDetailTableViewCell5 {
    
    override var orderDetail: OrderDetailResponse? {
        didSet {
            if let totalPrice = orderDetail?.totalPrice {
                let priceFormatter = totalPrice.numberFormatter()
                totalPriceLabel.text = priceFormatter + " ₫"
            }
        }
    }
    
    let totalPriceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textColor = MAIN_COLOR
        return l
    }()
    
    override func setupViews() {
        configureTitleLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .darkGray
        
        contentView.addSubview(totalPriceLabel)
        totalPriceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
}
