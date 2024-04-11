//
//  OrderSuccessViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class OrderSuccessViewController: UIViewController {
    
    var price: Float?
    let defaults = UserDefaults.standard
    var payment:Bool?
    var orderId: Int?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "success")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 18)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    let orderSuccessLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    let noticeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = MAIN_COLOR
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    lazy var backButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Quay Về Trang Chủ", for: .normal)
        b.setTitleColor(MAIN_COLOR, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.layer.borderWidth = 1
        b.layer.borderColor = MAIN_COLOR.cgColor
        b.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.defaults.set(nil, forKey: Keys.cartCount)
        
        if payment == false {
            navigationItem.title = "Đặt Hàng Thành Công"
            orderSuccessLabel.text = "Đặt hàng thành công"
            noticeLabel.text = "Vui lòng chuẩn bị số tiền cần thanh toán"
            
        } else {
            navigationItem.title = "Thanh Toán Thành Công"
            orderSuccessLabel.text = "Thanh toán thành công"
            noticeLabel.text = "Bạn đã thanh toán thành công đơn hàng \(orderId!) với số tiền"
        }
        
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.text = "Cảm ơn \(defaults.value(forKey: Keys.name)!)!"
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(orderSuccessLabel)
        orderSuccessLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        orderSuccessLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        orderSuccessLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        
        view.addSubview(noticeLabel)
        noticeLabel.topAnchor.constraint(equalTo: orderSuccessLabel.bottomAnchor, constant: 32).isActive = true
        noticeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        noticeLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        
        view.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: noticeLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        let priceFormatter = price!.numberFormatter()
        priceLabel.text = priceFormatter + " ₫"
        
        view.addSubview(backButton)
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    @objc func handleGoBack() {
        let tabbar = TabBarController()
        present(tabbar, animated: false, completion: nil)
    }
    
}
