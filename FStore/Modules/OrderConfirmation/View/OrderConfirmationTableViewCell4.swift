//
//  OrderConfirmationTableViewCell4.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderConfirmationTableViewCell4: OrderConfirmationTableViewCell3 {
    
    override var item: OrderConfirmationResponse? {
        didSet {
            
            if (defaults.value(forKey: "paymentMethodId") as? Int) == 1 {
                paymentMethodLabel.text = "Thanh toán khi nhận hàng"
                iconImageView.image = #imageLiteral(resourceName: "Dolar")
            }
            if (defaults.value(forKey: "paymentMethodId") as? Int) == 2 {
                paymentMethodLabel.text = "Thanh toán qua Thẻ Tín dụng"
                iconImageView.image = #imageLiteral(resourceName: "Credit-Card")
            }
            
        }
    }
    
    let defaults = UserDefaults.standard
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let paymentMethodLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    override func configureComponents() {
        accessoryType = .disclosureIndicator
        configureTitleLabel()
        
        contentView.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        contentView.addSubview(paymentMethodLabel)
        paymentMethodLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true
        paymentMethodLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8).isActive = true
        paymentMethodLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
}
