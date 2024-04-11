//
//  OrderTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit

class OrderTableViewCell: UITableViewCell {
    
    var order: OrderResponse? {
        didSet {
            if let name = order?.orderName {
                nameLabel.text = name
            }
            if let orderId = order?.orderId {
                orderIdLabel.text = "Mã đơn hàng: \(orderId)"
            }
            if let orderDate = order?.orderDate {
                let dateFormatter = Date()
                let dateString = dateFormatter.getFormattedDate(string: orderDate)
                orderDateLabel.text = "Đặt hàng: \(dateString)"
            }
            if let status = order?.orderStatus {
                if status == 1 {
                    orderStatusLabel.text = "Trạng thái: Đang xử lý"
                    iconImageView.image = #imageLiteral(resourceName: "pending")
                }
                if status == 2 {
                    orderStatusLabel.text = "Trạng thái: Đang giao hàng"
                    iconImageView.image = #imageLiteral(resourceName: "shipping")
                }
                if status == 3 {
                    orderStatusLabel.text = "Trạng thái: Giao hàng thành công"
                    iconImageView.image = #imageLiteral(resourceName: "order-success")
                }
                if status == 4 {
                    orderStatusLabel.text = "Trạng thái: Đã huỷ"
                    iconImageView.image = #imageLiteral(resourceName: "cancel")
                }
            }
        }
    }
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        return l
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let orderIdLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    let orderDateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    let orderStatusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(iconImageView)
        iconImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: iconImageView.leftAnchor, constant: -16).isActive = true
        
        contentView.addSubview(orderIdLabel)
        orderIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        orderIdLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        orderIdLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        orderIdLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(orderDateLabel)
        orderDateLabel.topAnchor.constraint(equalTo: orderIdLabel.bottomAnchor, constant: 8).isActive = true
        orderDateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        orderDateLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        orderDateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(orderStatusLabel)
        orderStatusLabel.topAnchor.constraint(equalTo: orderDateLabel.bottomAnchor, constant: 8).isActive = true
        orderStatusLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        orderStatusLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        orderStatusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        orderStatusLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
}
