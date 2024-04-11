//
//  ShippingAddressTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class ShippingAddressTableViewCell: UITableViewCell {
    
    var address: OrderConfirmationResponse? {
        didSet {
            if let name = address?.name, let phone = address?.phone {
                nameAndPhoneLabel.text = "\(name) - 0\(phone)"
            }
            if let street = address?.street, let communeWardTown = address?.communeWardTown, let district = address?.district, let provinceCity = address?.provinceCity {
                addressLabel.text = "\(street), \(communeWardTown), \(district), \(provinceCity)"
            }
            if let addressId = address?.id {
                if addressId == defaults.value(forKey: Keys.addressId) as? Int {
                    iconImageView.image = #imageLiteral(resourceName: "circle-selected")
                }
                else {
                    iconImageView.image = #imageLiteral(resourceName: "circle-unselected")
                }
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
    
    let nameAndPhoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(nameAndPhoneLabel)
        nameAndPhoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameAndPhoneLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        nameAndPhoneLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: nameAndPhoneLabel.bottomAnchor, constant: 4).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: nameAndPhoneLabel.leftAnchor).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: nameAndPhoneLabel.rightAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}

class ShippingAddressTableViewCell2: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.textLabel?.text = "Thêm địa chỉ mới"
        self.textLabel?.textColor = MAIN_COLOR
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
