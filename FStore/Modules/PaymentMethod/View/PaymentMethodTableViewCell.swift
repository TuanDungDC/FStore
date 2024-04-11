//
//  PaymentMethodTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    var payment: PaymentModel? {
        didSet {
            
            if let name = payment?.name {
                nameLabel.text = name
            }
            if let id = payment?.id {
                if id == defaults.value(forKey: Keys.paymentMethodId) as? Int {
                    iconImageView.image = #imageLiteral(resourceName: "circle-selected")
                }
                else {
                    iconImageView.image = #imageLiteral(resourceName: "circle-unselected")
                }
            }
            if let iconName = payment?.iconName {
                icon2ImageView.image = iconName
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
    
    let icon2ImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(icon2ImageView)
        icon2ImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        icon2ImageView.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        icon2ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon2ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: icon2ImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
