//
//  ShippingMethodViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class ShippingMethodViewControlle: UIViewController {
    
    private let cellId = "cellId"
    var shippingModel: [ShippingModel] = [ShippingModel(id: 1, name: "Giao hàng tiêu chuẩn", detail: "Giao hàng từ 5 - 7 ngày"), ShippingModel(id: 2, name: "Giao hàng nhanh", detail: "Giao hàng từ 3 - 5 ngày")]
    
    let defaults = UserDefaults.standard
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var selectButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Chọn", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(selectedPaymentMethod), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureBottomView()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        tableView.register(ShippingMethodTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        bottomView.addSubview(selectButton)
        selectButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        selectButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -28.5).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setupNavBar() {
        navigationItem.title = "Hình Thức Giao Hàng"
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func handleDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectedPaymentMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ShippingMethodViewControlle: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shippingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShippingMethodTableViewCell
        cell.shipping = shippingModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(shippingModel[indexPath.row].id!, forKey: Keys.shippingMethodId)
        self.tableView.reloadData()
    }
    
}
