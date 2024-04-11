//
//  OrderDetailViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class OrderDetailViewController: UIViewController {
    
    // MARK:- Variable Define
    private let cellId1 = "cellId1"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    private let cellId4 = "cellId4"
    private let cellId5 = "cellId5"
    private let cellId6 = "cellId6"
    
    var orderId: Int?
    let defaults = UserDefaults.standard
    var orderDetails: [OrderDetailResponse]?
    
    // MARK:- UI
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var orderCancelButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Huỷ Đơn Hàng", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.setTitleColor(MAIN_COLOR, for: .normal)
        b.layer.borderColor = MAIN_COLOR.cgColor
        b.layer.borderWidth = 1
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleOrderCancel), for: .touchUpInside)
        return b
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.sectionHeaderHeight = 0
        tbv.sectionFooterHeight = 0
        return tbv
    }()
    
    var bottomViewHeightConstraint: NSLayoutConstraint?
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureBottomView()
        configureTableView()
        fetchData()
    }
    
    // MARK:- Navigation
    private func setupNavBar() {
        navigationItem.title = "Đơn Hàng"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
//    private func fetchData() {
//        guard let url = URL(string: ORDER_DETAIL_API_URL) else { return }
//        let parameters: Parameters = ["orderId": orderId!, "userId": defaults.value(forKey: Keys.id)!]
//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultMaskType(.black)
//        
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] response in
//            switch response.result {
//            case .success(let data):
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    do {
//                        let orderDetails = try decoder.decode([OrderDetailResponse].self, from: data)
//                        self?.orderDetails = orderDetails
//                        self?.tableView.reloadData()
//                        SVProgressHUD.dismiss()
//                    } catch {
//                        SVProgressHUD.showError(withStatus: "JSON Decoding Error: \(error.localizedDescription)")
//                    }
//                } else {
//                    SVProgressHUD.showError(withStatus: "No data received from the server.")
//                }
//            case .failure(let error):
//                SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func fetchData() {
       guard let url = URL(string: ORDER_DETAIL_API_URL) else {return}
       let parameters: Parameters = ["orderId": orderId!, "userId": defaults.value(forKey: Keys.id)!]
       SVProgressHUD.show()
       SVProgressHUD.setDefaultMaskType(.black)
       
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [OrderDetailResponse].self) { [weak self] response in
            switch response.result {
            case .success(let orderDetails):
                self?.orderDetails = orderDetails
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
    
    @objc private func handleOrderCancel() {
        let alertController = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn huỷ đơn hàng này?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Có", style: .default) { [weak self] (action) in
            self?.orderCancel()
        }
        let noAction = UIAlertAction(title: "Không", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func orderCancel() {
        guard let url = URL(string: ORDER_CANCEL_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "orderId": orderId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                           let error = json["error"] as? Bool, error == false {
                            self?.bottomViewHeightConstraint?.constant = 0
                            self?.fetchData()
                            SVProgressHUD.dismiss()
                        } else {
                            SVProgressHUD.showError(withStatus: "Error parsing response.")
                        }
                    } catch {
                        SVProgressHUD.showError(withStatus: "Error: \(error.localizedDescription)")
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "No data received from the server.")
                }
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
            }
        }
    }

    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomViewHeightConstraint = NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        view.addConstraint(bottomViewHeightConstraint!)
        
        bottomView.addSubview(orderCancelButton)
        orderCancelButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        orderCancelButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        orderCancelButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        orderCancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        tableView.register(OrderDetailTableViewCell1.self, forCellReuseIdentifier: cellId1)
        tableView.register(OrderDetailTableViewCell2.self, forCellReuseIdentifier: cellId2)
        tableView.register(OrderDetailTableViewCell3.self, forCellReuseIdentifier: cellId3)
        tableView.register(OrderDetailTableViewCell4.self, forCellReuseIdentifier: cellId4)
        tableView.register(OrderDetailTableViewCell5.self, forCellReuseIdentifier: cellId5)
        tableView.register(OrderDetailTableViewCell6.self, forCellReuseIdentifier: cellId6)
    }
    
    func showProductDetail(productId: Int) {
        let detail = ProductDetailViewController()
        detail.productId = productId
        navigationController?.pushViewController(detail, animated: true)
    }
    
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderDetailTableViewCell1
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! OrderDetailTableViewCell1
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! OrderDetailTableViewCell2
        }
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! OrderDetailTableViewCell3
        }
        else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId4, for: indexPath) as! OrderDetailTableViewCell4
        }
        else if indexPath.section == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId5, for: indexPath) as! OrderDetailTableViewCell5
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId6, for: indexPath) as! OrderDetailTableViewCell6
        }
        
        cell.orderDetail = orderDetails?[indexPath.section]
        cell.orderDetailViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 80
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 999
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
    
}
