//
//  OrderDetailTableViewCell2.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderDetailTableViewCell2: OrderDetailTableViewCell1 {
    
    override var orderDetail: OrderDetailResponse? {
        didSet {
            if let title = orderDetail?.title {
                titleLabel.text = title
            }
            if let name = orderDetail?.name {
                nameLabel.text = name
            }
            
            if let phone = orderDetail?.phone {
                phoneLabel.text = "0\(phone)"
            }
            if let street = orderDetail?.street, let communeWardTown = orderDetail?.communeWardTown, let district = orderDetail?.district, let provinceCity = orderDetail?.provinceCity {
                addressLabel.text = "\(street), \(communeWardTown), \(district), \(provinceCity)"
            }
        }
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.numberOfLines = 0
        return l
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    let phoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    let addressLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        l.numberOfLines = 0
        return l
    }()
    
    override func setupViews() {
        configureTitleLabel()
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: phoneLabel.leftAnchor).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: phoneLabel.rightAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
}
