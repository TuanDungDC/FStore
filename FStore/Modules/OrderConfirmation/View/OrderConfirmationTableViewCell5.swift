//
//  OrderConfirmationTableViewCell5.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderConfirmationTableViewCell5: OrderConfirmationTableViewCell4 {
    
    override var item: OrderConfirmationResponse? {
        didSet {
            if let provisionalPrice = item?.provisionalPrice {
                let priceFormatter = provisionalPrice.numberFormatter() + " ₫"
                var fee: Float = 0
                provisionalPriceValueLabel.text = priceFormatter
                
                // Thanh toán khi nhận hàng
                if (defaults.value(forKey: Keys.paymentMethodId) as? Int) == 1 {
                    if provisionalPrice <= Float(200000) {
                        if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 1 {
                            fee += 20000
                        }
                        if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                            fee += 30000
                        }
                    }
                    else {
                        if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                            fee += 30000
                        }
                    }
                    
                    let priceFormatter = fee.numberFormatter()
                    DispatchQueue.main.async {
                        self.transportFeeValueLabel.text = priceFormatter + " ₫"
                    }
                }
                    
                // Thanh toán chuyển khoản
                else {
                    if provisionalPrice <= Float(200000) {
                        if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                            fee += 15000
                        }
                    }
                    else {
                        if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                            fee += 15000
                        }
                    }
                    let priceFormatter = fee.numberFormatter()
                    DispatchQueue.main.async {
                        self.transportFeeValueLabel.text = "\(priceFormatter) ₫"
                    }
                }
                
            }
        }
    }
    
    let defaults3 = UserDefaults.standard
    
    let provisionalPriceTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.text = "Tạm tính"
        return l
    }()

    let provisionalPriceValueLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()

    let transportFeeTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.text = "Phí vận chuyển"
        return l
    }()

    let transportFeeValueLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    override func configureComponents() {
        
        contentView.addSubview(provisionalPriceTitleLabel)
        provisionalPriceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        provisionalPriceTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true

        contentView.addSubview(provisionalPriceValueLabel)
        provisionalPriceValueLabel.centerYAnchor.constraint(equalTo: provisionalPriceTitleLabel.centerYAnchor).isActive = true
        provisionalPriceValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true

        contentView.addSubview(transportFeeTitleLabel)
        transportFeeTitleLabel.topAnchor.constraint(equalTo: provisionalPriceTitleLabel.bottomAnchor, constant: 24).isActive = true
        transportFeeTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        transportFeeTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true

        contentView.addSubview(transportFeeValueLabel)
        transportFeeValueLabel.centerYAnchor.constraint(equalTo: transportFeeTitleLabel.centerYAnchor).isActive = true
        transportFeeValueLabel.rightAnchor.constraint(equalTo: provisionalPriceValueLabel.rightAnchor).isActive = true
        
    }
    
}
