//
//  ShippingAddressViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class ShippingAddressViewController: UIViewController {
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    let defaults = UserDefaults.standard
    var address: [OrderConfirmationResponse]?
    
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.sectionHeaderHeight = 0
        tbv.sectionFooterHeight = 0
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tbv
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var selectionAddressButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Giao Đến Địa Chỉ Này", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleSelectionAddress), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        tableView.register(ShippingAddressTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ShippingAddressTableViewCell2.self, forCellReuseIdentifier: cellId2)
        
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        bottomView.addSubview(selectionAddressButton)
        selectionAddressButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        selectionAddressButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        selectionAddressButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -28.5).isActive = true
        selectionAddressButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        fetchData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    @objc private func handleSelectionAddress() {
        guard let addressId = defaults.value(forKey: "addressId") else {
            showAlert(title: "Lỗi", message: "Vui lòng chọn địa chỉ nhận hàng.")
            return
        }
        guard let url = URL(string: CHANGE_DEFAULT_ADDRESS_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "addressId": addressId]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value["error"] as? Bool
                        if error == false {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    print(error)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }

    private func setupNavBar() {
        navigationItem.title = "Địa Chỉ Nhận Hàng"
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchData() {
        guard let url = URL(string: SHIPPING_ADDRESS_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let address = try decoder.decode([OrderConfirmationResponse].self, from: data)
                    self?.address = address
                    self?.tableView.reloadData()
                } catch let err {
                    print(err)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }
}


extension ShippingAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return address?.count ?? 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShippingAddressTableViewCell
            cell.address = address?[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! ShippingAddressTableViewCell2
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.black)
            defaults.set(address?[indexPath.row].id, forKey: Keys.addressId)
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
        else {
            let addShippingAddressViewController = AddShippingAddressViewController()
            let navBar = UINavigationController(rootViewController: addShippingAddressViewController)
            DispatchQueue.main.async {
                self.present(navBar, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Xoá") { [unowned self] (action, view, completionHandler) in
            let addressId = self.address?[indexPath.row].id
            if addressId == self.defaults.value(forKey: Keys.addressId) as? Int {
                self.showAlert(title: "Lỗi", message: "Địa chỉ đang được chọn. Vui lòng xoá địa chỉ khác")
                completionHandler(false)
                return
            }
            guard let url = URL(string: DELETE_ADDRESS_API_URL) else { return }
            let parameters: Parameters = ["addressId": addressId!, "userId": self.defaults.value(forKey: Keys.id)!]
            
            // Cập nhật cú pháp yêu cầu Alamofire
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success:
                    self.fetchData()
                case .failure(let error):
                    print(error)
                }
                completionHandler(true)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Sửa") { (action, view, completionHandler) in
            let editShippingAddress = EditShippingAddressViewController()
            editShippingAddress.addressId = self.address![indexPath.row].id!
            let navigation = UINavigationController(rootViewController: editShippingAddress)
            DispatchQueue.main.async {
                self.present(navigation, animated: true, completion: nil)
            }
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        editAction.backgroundColor = UIColor(red: 92 / 255, green: 132 / 255, blue: 176 / 255, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
