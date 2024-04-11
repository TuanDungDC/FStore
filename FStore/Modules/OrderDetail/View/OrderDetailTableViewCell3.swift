//
//  OrderDetailTableViewCell3.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit

class OrderDetailTableViewCell3: OrderDetailTableViewCell2 {
    
    override var orderDetail: OrderDetailResponse? {
        didSet {
            if let shippingMethod = orderDetail?.shippingMethod {
                if shippingMethod == 1 {
                    typeLabel.text = "Giao hàng tiêu chuẩn"
                }
                if shippingMethod == 2 {
                    typeLabel.text = "Giao hàng nhanh"
                }
            }
        }
    }
    
    let typeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    override func setupViews() {
        configureTitleLabel()
        
        contentView.addSubview(typeLabel)
        typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}
