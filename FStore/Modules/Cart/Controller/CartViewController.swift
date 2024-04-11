//
//  CartViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD


class CartViewController: UIViewController {
    
    private let cellId = "cellId"
    let defaults = UserDefaults.standard
    var price: Float?
    var products: [ProductResponse]? {
        didSet {
            if let count = products?.count {
                if count > 0 {
                    DispatchQueue.main.async {
                        self.bottomViewHeightConstraint?.constant = 123
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.bottomViewHeightConstraint?.constant = 0
                        let emptyView = EmptyView()
                        emptyView.noticeString = "Bạn chưa có sản phẩm nào trong giỏ hàng"
                        self.tableView.backgroundView = emptyView
                    }
                }
            }
            self.updateCart()
        }
    }
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.tableFooterView = UIView()
        tbv.estimatedSectionHeaderHeight = 0
        tbv.estimatedSectionFooterHeight = 0
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tbv
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    let totalMoneyLabel: UILabel = {
        let l = UILabel()
        l.textColor = MAIN_COLOR
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.text = "0 ₫"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return v
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Thành tiền"
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var orderButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Tiến Hành Đặt Hàng", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleOrder), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureBottomView()
        configureTableView()
        fetchData()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Giỏ Hàng"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleOrder() {
        let orderConfirmationViewController = OrderConfirmation()
        orderConfirmationViewController.provisionalPrice = price
        navigationController?.pushViewController(orderConfirmationViewController, animated: true)
    }
    
    var bottomViewHeightConstraint: NSLayoutConstraint?
    
    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomViewHeightConstraint = NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
        view.addConstraint(bottomViewHeightConstraint!)
        
        
        bottomView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        bottomView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        
        bottomView.addSubview(totalMoneyLabel)
        totalMoneyLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        totalMoneyLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        
        bottomView.addSubview(orderButton)
        orderButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        orderButton.rightAnchor.constraint(equalTo: totalMoneyLabel.rightAnchor).isActive = true
        orderButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    @objc private func handleRefresh() {
        self.fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: CART_API_URL) else { return }
        let parameters: Parameters = ["user_id": defaults.value(forKey: Keys.id) ?? -1]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
                if self?.tableView.refreshControl?.isRefreshing == true {
                    self?.tableView.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func updateCart() {
        var cartCount = 0
        var price: Float = 0
        for product in products! {
            cartCount += product.quantity!
            if product.isSale == 1 {
                price += product.salePrice! * Float(product.quantity!)
            }
            if product.isSale == 0 {
                price += product.price! * Float(product.quantity!)
            }
            self.price = price
            let priceFormatter = price.numberFormatter()
            self.totalMoneyLabel.text = priceFormatter + " ₫"
        }
        if cartCount != 0 {
            self.navigationItem.title = "Giỏ Hàng (\(cartCount))"
            defaults.set(cartCount, forKey: Keys.cartCount)
        }
        else {
            self.navigationItem.title = "Giỏ Hàng"
            defaults.set(nil, forKey: Keys.cartCount)
        }
    }
    
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CartTableViewCell
        cell.product = products?[indexPath.item]
        cell.cartViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
