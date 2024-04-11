//
//  ProductDetailTableViewCell2.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit

class ProductDetailTableViewCell2: ProductDetailTableViewCell1 {
    
    override var detail: ProductDetailResponse? {
        didSet {
            if let title = detail?.title {
                titleLabel.text = title
            }
            if let description = detail?.description {
                textView.text = description
            }
        }
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return v
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.contentInset = UIEdgeInsets(top: -10, left: -4, bottom: 0, right: 0)
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
        tv.sizeToFit()
        tv.textColor = UIColor(white: 0.2, alpha: 1)
        return tv
    }()
    
    func setupLayoutConstraintTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    override func setupViews() {
        contentView.addSubview(titleLabel)
        setupLayoutConstraintTitleLabel()
        
        contentView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        contentView.addSubview(textView)
        textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
