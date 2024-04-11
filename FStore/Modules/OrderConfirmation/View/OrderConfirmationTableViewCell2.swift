//
//  OrderConfirmationTableViewCell2.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderConfirmationTableViewCell2: OrderConfirmationTableViewCell1 {
    
    override var item: OrderConfirmationResponse? {
        didSet {
            addressLabel.text = ""
            if let name = item?.name, let phone = item?.phone {
                nameAndPhoneLabel.text = "\(name) - 0\(phone)"
                nameAndPhoneLabel.textColor = .black
            }
            else {
                nameAndPhoneLabel.font = UIFont.systemFont(ofSize: 14)
                nameAndPhoneLabel.textColor = .orange
                nameAndPhoneLabel.text = "Bạn chưa có địa chỉ nhận hàng. Vui lòng thêm địa chỉ nhận hàng!"
            }
            if let street = item?.street, let communeWardTown = item?.communeWardTown, let district = item?.district, let provinceCity = item?.provinceCity {
                addressLabel.text = "\(street), \(communeWardTown), \(district), \(provinceCity)"
            }
        }
    }
    
    let nameAndPhoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let addressLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.numberOfLines = 0
        return l
    }()
    
    func configureNameAndPhoneLabel() {
        contentView.addSubview(nameAndPhoneLabel)
        nameAndPhoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        nameAndPhoneLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        nameAndPhoneLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    override func configureComponents() {
        accessoryType = .disclosureIndicator
        
        configureTitleLabel()
        configureNameAndPhoneLabel()
        
        contentView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameAndPhoneLabel.bottomAnchor, constant: 4).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: nameAndPhoneLabel.leftAnchor).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}
