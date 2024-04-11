//
//  CartTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class CartTableViewCell: ProductTableViewCell, CustomStepperDelegate {
    
    override var product: ProductResponse? {
        didSet {
            if let quantity = product?.quantity {
                quantityStepper.stepperValue = quantity
            }
        }
    }
    
    let defaults = UserDefaults.standard
    var cartViewController: CartViewController?
    
    lazy var deleteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .lightGray
        b.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return b
    }()
    
    lazy var quantityStepper: CustomStepper = {
        let s = CustomStepper()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.delegate = self
        return s
    }()
    
    override func configureProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 118).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
    }
    
    override func configureComponents() {
        configureProductImageView()
        configureDeleteButton()
        configureNameLabel()
        configurePriceLabel()
        configureOriginPriceLabel()
        configureQuantityStepper()
        
    }
    
    func configureDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func configureNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 0
        nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -16).isActive = true
    }
    
    override func configureOriginPriceLabel() {
        contentView.addSubview(originPriceLabel)
        originPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        originPriceLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        originPriceLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }

    func configureQuantityStepper() {
        contentView.addSubview(quantityStepper)
        quantityStepper.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16).isActive = true
        quantityStepper.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        quantityStepper.widthAnchor.constraint(equalToConstant: 100).isActive = true
        quantityStepper.heightAnchor.constraint(equalToConstant: 22).isActive = true
        quantityStepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -56).isActive = true
    }
    
    @objc func handleDelete() {
        delete()
    }

    private func delete() {
        guard let url = URL(string: DELETE_CART_PRODUCT_API_URL) else { return }
        
        let parameters: Parameters?
        
        if product?.attributeId == nil {
             parameters = ["productId": product!.id!, "userId": defaults.value(forKey: Keys.id)!]
        } else {
            parameters = ["productId": product!.id!, "attributeId": product!.attributeId!, "userId": defaults.value(forKey: Keys.id)!]
        }
       
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).response { [weak self] _ in
            self?.updateCart()
            SVProgressHUD.dismiss()
        }
    }

    
    private func updateCart() {
        guard let url = URL(string: QUANTITY_UPDATE) else { return }
        let parameters: Parameters?
        if product?.attributeId == nil {
            parameters = ["quantity": quantityStepper.stepperValue, "userId": defaults.value(forKey: Keys.id)!, "productId": product!.id!]
        } else {
            parameters = ["quantity": quantityStepper.stepperValue, "userId": defaults.value(forKey: Keys.id)!, "productId": product!.id!, "attributeId": product!.attributeId!]
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).response { [weak self] _ in
            self?.cartViewController?.fetchData()
            SVProgressHUD.dismiss()
        }
    }
    
    func didSub(_: CustomStepper) {
        updateCart()
    }
    
    func didAdd(_: CustomStepper) {
        updateCart()
    }
    
}
