//
//  OrderDetailTableViewCell5.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit

class OrderDetailTableViewCell5: OrderDetailTableViewCell4 {
    
    override var orderDetail: OrderDetailResponse? {
        didSet {
            
            tableView.reloadData()
            
            if let provisionalPrice = orderDetail?.provisionalPrice {
                let priceFormatter = provisionalPrice.numberFormatter()
                provisionalPriceValueLabel.text = priceFormatter + " ₫"
            }
            if let transportFee = orderDetail?.transportFee {
                let priceFormatter = transportFee.numberFormatter()
                transportFeeValueLabel.text = priceFormatter + " ₫"
            }
        }
    }
    
    private let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tbv.layer.borderWidth = 0.5
        tbv.layer.masksToBounds = true
        tbv.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
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
    
    override func setupViews() {
        configureTitleLabel()
        
        contentView.autoresizingMask = .flexibleHeight
        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -84).isActive = true
        tableView.register(ProductCell.self, forCellReuseIdentifier: cellId)
        
        contentView.addSubview(provisionalPriceTitleLabel)
        provisionalPriceTitleLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        provisionalPriceTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        provisionalPriceTitleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(provisionalPriceValueLabel)
        provisionalPriceValueLabel.centerYAnchor.constraint(equalTo: provisionalPriceTitleLabel.centerYAnchor).isActive = true
        provisionalPriceValueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        provisionalPriceValueLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(transportFeeTitleLabel)
        transportFeeTitleLabel.topAnchor.constraint(equalTo: provisionalPriceTitleLabel.bottomAnchor, constant: 24).isActive = true
        transportFeeTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        transportFeeTitleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        contentView.addSubview(transportFeeValueLabel)
        transportFeeValueLabel.centerYAnchor.constraint(equalTo: transportFeeTitleLabel.centerYAnchor).isActive = true
        transportFeeValueLabel.rightAnchor.constraint(equalTo: provisionalPriceValueLabel.rightAnchor).isActive = true
        transportFeeValueLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
    }
    
    private class ProductCell: ProductTableViewCell {
        
        override var product: ProductResponse? {
            didSet {
                
                if let name = product?.name {
                    nameLabel.text = name
                }
                
                if let thumbnailUrl = product?.thumbnailUrl {
                    productImageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
                }
                
                if product?.isSale == 1 {
                    guard let price = product?.salePrice else { return }
                    let priceFormatter = price.numberFormatter()
                    priceLabel.text = priceFormatter + " ₫"
                }
                    
                else {
                    guard let price = product?.price else { return }
                    let priceFormatter = price.numberFormatter()
                    priceLabel.text = priceFormatter + " ₫"
                }
                
                if let quantity = product?.quantity {
                    quantityLabel.text = "x \(quantity)"
                }
                
            }
        }
        
        let quantityLabel: UILabel = {
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            l.font = UIFont.systemFont(ofSize: 14)
            return l
        }()
        
        override func configureComponents() {
            contentView.addSubview(productImageView)
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
            productImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor, constant: -10).isActive = true
            
            contentView.addSubview(nameLabel)
            nameLabel.numberOfLines = 0
            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 16).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
            
            contentView.addSubview(priceLabel)
            priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
            priceLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -70).isActive = true
            
            contentView.addSubview(quantityLabel)
            quantityLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
            quantityLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        }
        
    }
    
}

extension OrderDetailTableViewCell5: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        cell.product = orderDetail?.products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableView.layoutIfNeeded()
        self.layoutIfNeeded()
        let contentSize = tableView.contentSize
        return CGSize(width: contentSize.width, height: contentSize.height + 132)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productId = orderDetail?.products?[indexPath.row].id {
            orderDetailViewController?.showProductDetail(productId: productId)
        }
    }
    
}
