//
//  ShippingMethodTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class ShippingMethodTableViewCell: UITableViewCell {
    
    var shipping: ShippingModel? {
        didSet {
            
            if let name = shipping?.name {
                nameLabel.text = name
            }
            if let id = shipping?.id {
                if id == defaults.value(forKey: Keys.shippingMethodId) as? Int {
                    iconImageView.image = #imageLiteral(resourceName: "circle-selected")
                }
                else {
                    iconImageView.image = #imageLiteral(resourceName: "circle-unselected")
                }
            }
            if let detail = shipping?.detail {
                detailLabel.text = detail
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
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let detailLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
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
        
        contentView.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(detailLabel)
        detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 12).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
