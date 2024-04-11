//
//  OrderDetailTableViewCell1.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderDetailTableViewCell1: UITableViewCell {
    
    var orderDetail: OrderDetailResponse? {
        didSet {
            if let orderId = orderDetail?.orderId {
                orderIdLabel.text = "Mã đơn hàng: \(orderId)"
            }
            if let orderDate = orderDetail?.orderDate {
                let date = Date()
                let dateFormatter = date.getFormattedDate(string: orderDate)
                orderDateLabel.text = "Ngày đặt hàng: \(dateFormatter)"
            }
            if let orderStatus = orderDetail?.orderStatus, let paymentMethod = orderDetail?.paymentMethod {
                if orderStatus == 1 {
                    orderStatusLabel.text = "Trạng thái: Đang xử lý"
                    if paymentMethod == 1 {
                        DispatchQueue.main.async {
                            self.orderDetailViewController?.bottomViewHeightConstraint?.constant = 77
                        }
                    }
                    if paymentMethod == 2 {
                        DispatchQueue.main.async {
                            self.orderDetailViewController?.bottomViewHeightConstraint?.constant = 0
                        }
                    }
                }
                if orderStatus == 2 {
                    orderStatusLabel.text = "Trạng thái: Đang giao hàng"
                }
                if orderStatus == 3 {
                    orderStatusLabel.text = "Trạng thái: Giao hàng thành công"
                }
                if orderStatus == 4 {
                    orderStatusLabel.text = "Trạng thái: Đã huỷ"
                }
            }
        }
    }
    
    var orderDetailViewController: OrderDetailViewController?
    
    let orderIdLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.numberOfLines = 0
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
        selectionStyle = .none
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(orderIdLabel)
        orderIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        orderIdLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        orderIdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        orderIdLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        contentView.addSubview(orderDateLabel)
        orderDateLabel.topAnchor.constraint(equalTo: orderIdLabel.bottomAnchor, constant: 16).isActive = true
        orderDateLabel.leftAnchor.constraint(equalTo: orderIdLabel.leftAnchor).isActive = true
        orderDateLabel.rightAnchor.constraint(equalTo: orderIdLabel.rightAnchor).isActive = true
        orderDateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(orderStatusLabel)
        orderStatusLabel.topAnchor.constraint(equalTo: orderDateLabel.bottomAnchor, constant: 8).isActive = true
        orderStatusLabel.leftAnchor.constraint(equalTo: orderDateLabel.leftAnchor).isActive = true
        orderStatusLabel.rightAnchor.constraint(equalTo: orderDateLabel.rightAnchor).isActive = true
        orderStatusLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        orderStatusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
}
