//
//  ProductPurchasedTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class ProductPurchasedTableViewController: UITableViewController {
    
    // MARK:- Variable Define
    private let cellId = "cellId"
    let defaults = UserDefaults.standard
    var products: [ProductResponse]? {
        didSet {
            if products?.count == 0 {
                let emptyView = EmptyView()
                emptyView.noticeString = "Bạn chưa mua sản phẩm nào"
                self.tableView.backgroundView = emptyView
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(ProductPurchasedTableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchData()
    }
    
    // MARK:- Navigation
    private func setupNavBar() {
        navigationItem.title = "Đã Mua"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Fetch Data
    private func fetchData() {
        guard let url = URL(string: PRODUCT_PURCHASED_API_URL) else { return }
        guard let userId = defaults.string(forKey: Keys.id) else {
            // Xử lý trường hợp userId là nil
            return
        }
        let parameters: Parameters = ["userId": userId]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                // Xử lý lỗi ở đây, ví dụ hiển thị thông báo cho người dùng
            }
        }
    }

}

// MARK:- Extension
extension ProductPurchasedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductPurchasedTableViewCell
        cell.product = products?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.productId = products?[indexPath.item].id
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
}
