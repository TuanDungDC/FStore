//
//  OrderConfirmationTableViewCell1.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderConfirmationTableViewCell1: UITableViewCell {
    
    var item: OrderConfirmationResponse? {
        didSet {
            if let title = item?.title {
                titleLabel.text = title
            }
            if let count = item?.products?.count {
                collectionViewHeightConstraint?.constant = CGFloat(count) * heightItem + (CGFloat(count) - 1) * 8
            }
            collectionView.reloadData()
        }
    }
    
    var orderConfirmationViewController: OrderConfirmation?
    
    private let cellId = "cellId"
    let heightItem: CGFloat = 70
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 1
        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureComponents() {
        configureTitleLabel()
        configureCollectionView()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    var collectionViewHeightConstraint: NSLayoutConstraint?
    
    func configureCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        collectionViewHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        contentView.addConstraint(collectionViewHeightConstraint!)
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    private class ProductCell: ProductCollectionViewCell {

        override var productResponse: ProductResponse? {
            didSet {
                if let quantity = productResponse?.quantity {
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

        override func setupViews() {
            backgroundColor = .white
            contentView.addSubview(imageView)
            imageView.layer.cornerRadius = 0
            imageView.layer.borderWidth = 0
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1, constant: -10).isActive = true

            contentView.addSubview(priceLabel)
            priceLabel.font = UIFont.systemFont(ofSize: 14)
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -8).isActive = true
            priceLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true

            contentView.addSubview(quantityLabel)
            quantityLabel.rightAnchor.constraint(equalTo: priceLabel.rightAnchor).isActive = true
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 8).isActive = true
            quantityLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true

            contentView.addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -16).isActive = true
        }

    }
    
    
}

extension OrderConfirmationTableViewCell1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        cell.productResponse = item?.products?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: heightItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
