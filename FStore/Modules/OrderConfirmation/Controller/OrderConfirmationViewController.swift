//
//  RegisterView.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class OrderConfirmation: UIViewController {
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    private let cellId4 = "cellId4"
    private let cellId5 = "cellId5"
    
    let defaults = UserDefaults.standard
    var provisionalPrice: Float?
    var order: [OrderConfirmationResponse]?
    let paymentId = UserDefaults.standard.value(forKey: Keys.paymentMethodId)
    var fee: Float?
    var totalPrice: Float?
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.sectionHeaderHeight = 0
        tbv.sectionFooterHeight = 0
        tbv.tableFooterView = UIView()
        tbv.estimatedSectionHeaderHeight = 0
        tbv.estimatedSectionFooterHeight = 0
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tbv.separatorStyle = .none
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
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleSelectionButton), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.value(forKey: Keys.paymentMethodId) == nil {
            defaults.set(1, forKey: Keys.paymentMethodId)
        }
        if defaults.value(forKey: Keys.shippingMethodId) == nil {
            defaults.set(1, forKey: Keys.shippingMethodId)
        }
        
        setupNavBar()
        configureBottomView()
        configureTableView()
        fetchData()
        setupSelectButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
        setupSelectButton()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Xác Nhận Đơn Hàng"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupSelectButton() {
        if (defaults.value(forKey: Keys.paymentMethodId) as! Int) == 1 {
            orderButton.setTitle("Đặt Hàng", for: .normal)
        } else {
            orderButton.setTitle("Thanh Toán Đơn Hàng", for: .normal)
        }
    }
    
    @objc private func handleSelectionButton() {
        if (defaults.value(forKey: Keys.paymentMethodId) as! Int) == 1 {
            handleOrder()
        } else {
            handlePayment()
        }
    }
    
    @objc func handlePayment() {
        let paymentVC = CreditCardPaymentViewController()
        paymentVC.amount = provisionalPrice!
        paymentVC.fee = fee!
        paymentVC.totalPrice = totalPrice!
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    @objc func handleOrder() {
        if order?[1].id == nil {
            let alertController = UIAlertController(title: "", message: "Vui lòng thêm địa chỉ nhận hàng!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        order(amount: provisionalPrice!, fee: fee!, totalPrice: totalPrice!)
        
    }
    
    private func order(amount: Float, fee: Float, totalPrice: Float) {
        guard let url = URL(string: ORDER_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "amount": amount, "fee": fee, "totalPrice": totalPrice, "shippingMethod": defaults.value(forKey: Keys.shippingMethodId)!, "paymentMethod": defaults.value(forKey: Keys.paymentMethodId)!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                           let error = json[Keys.error] as? Bool, error == false {
                            SVProgressHUD.dismiss()
                            let vc = OrderSuccessViewController()
                            vc.price = totalPrice
                            vc.payment = false
                            let navBar = UINavigationController(rootViewController: vc)
                            DispatchQueue.main.async {
                                self.present(navBar, animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.showError(withStatus: "Error parsing response.")
                        }
                    } catch {
                        SVProgressHUD.showError(withStatus: "Error: \(error.localizedDescription)")
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "No data received.")
                }
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func updatePrice() {
        guard var provisionalPrice = provisionalPrice else { return }
        // Thanh toán khi nhận hàng
        if (defaults.value(forKey: Keys.paymentMethodId) as? Int) == 1 {
            if provisionalPrice <= Float(200000) {
                if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 1 {
                    fee = 20000
                }
                if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                    fee = 30000
                }
                
            }
            else {
                if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                    fee = 30000
                }
                else {
                    fee = 0
                }
            }
            
            provisionalPrice += fee!
            self.totalPrice = provisionalPrice
            let priceFormatter = provisionalPrice.numberFormatter()
            DispatchQueue.main.async {
                self.totalMoneyLabel.text = priceFormatter + " ₫"
            }
        }
        // Thanh toán chuyển khoản
        else {
            if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 1 {
                fee = 0
            }
            if (defaults.value(forKey: Keys.shippingMethodId) as? Int) == 2 {
                fee = 15000
            }
            provisionalPrice += fee!
            self.totalPrice = provisionalPrice
            let priceFormatter = provisionalPrice.numberFormatter()
            DispatchQueue.main.async {
                self.totalMoneyLabel.text = priceFormatter + " ₫"
            }
        }
        
        bottomViewHeightConstraint?.constant = 123
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
        tableView.register(OrderConfirmationTableViewCell1.self, forCellReuseIdentifier: cellId)
        tableView.register(OrderConfirmationTableViewCell2.self, forCellReuseIdentifier: cellId2)
        tableView.register(OrderConfirmationTableViewCell3.self, forCellReuseIdentifier: cellId3)
        tableView.register(OrderConfirmationTableViewCell4.self, forCellReuseIdentifier: cellId4)
        tableView.register(OrderConfirmationTableViewCell5.self, forCellReuseIdentifier: cellId5)
    }
    
    private func fetchData() {
        guard let url = URL(string: ORDER_CONFIRMATION_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let order = try decoder.decode([OrderConfirmationResponse].self, from: data)
                        self?.order = order
                        self?.tableView.reloadData()
                        self?.updatePrice()
                        SVProgressHUD.dismiss()
                    } catch {
                        SVProgressHUD.showError(withStatus: "JSON Decoding Error: \(error.localizedDescription)")
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "No data received from the server.")
                }
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
            }
        }
    }
}

extension OrderConfirmation: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return order?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: OrderConfirmationTableViewCell1
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderConfirmationTableViewCell1
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! OrderConfirmationTableViewCell2
        }
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! OrderConfirmationTableViewCell3
        }
        else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId4, for: indexPath) as! OrderConfirmationTableViewCell4
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId5, for: indexPath) as! OrderConfirmationTableViewCell5
        }
        cell.item = order?[indexPath.section]
        cell.orderConfirmationViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let shippingAddress = ShippingAddressViewController()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(shippingAddress, animated: true)
            }
        }
        if indexPath.section == 2 {
            let shippingMethod = ShippingMethodViewControlle()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(shippingMethod, animated: true)
            }
        }
        if indexPath.section == 3 {
            let paymentMethod = PaymentMethodViewController()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(paymentMethod, animated: true)
            }
        }
    }
    
}
