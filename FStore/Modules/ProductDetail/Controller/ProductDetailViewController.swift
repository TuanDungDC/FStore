//
//  ProductDetailViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit
import Alamofire
import SVProgressHUD
import GSImageViewerController

class ProductDetailViewController: UIViewController {
    
    // MARK:- Variable Define
    private let cellId1 = "cellId1"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"
    
    var details: [ProductDetailResponse]?
    let defaults = UserDefaults.standard
    var productId: Int?
    
    // MARK:- UI
    lazy var shoppingCartButton: SSBadgeButton = {
        let b = SSBadgeButton()
        b.setImage(#imageLiteral(resourceName: "cart").withRenderingMode(.alwaysTemplate), for: .normal)
        b.badgeFont = UIFont.boldSystemFont(ofSize: 12)
        b.addTarget(self, action: #selector(presentCart), for: .touchUpInside)
        b.frame = CGRect(x: 0, y: 0, width: 44, height: 36)
        b.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 10)
        b.badgeBackgroundColor = BADGE_BACKGROUND_COLOR
        b.adjustsImageWhenHighlighted = false
        return b
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .white
        tbv.delegate = self
        tbv.dataSource = self
        tbv.sectionHeaderHeight = 0
        tbv.sectionFooterHeight = 0
        tbv.separatorStyle = .none
        return tbv
    }()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureTableView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cartCount = UserDefaults.standard.value(forKey: Keys.cartCount) as? Int
        if cartCount == nil {
            shoppingCartButton.badge = nil
        }
        else if cartCount == 0 {
            shoppingCartButton.badge = nil
        }
        else {
            shoppingCartButton.badge = "\(cartCount!)"
        }
    }
    
    private func setupNavBar() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shoppingCartButton)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(ProductDetailTableViewCell1.self, forCellReuseIdentifier: cellId1)
        tableView.register(ProductDetailTableViewCell2.self, forCellReuseIdentifier: cellId2)
        tableView.register(ProductDetailTableViewCell3.self, forCellReuseIdentifier: cellId3)
    }
    
    private func fetchData() {
        guard let url = URL(string: PRODUCT_DETAIL_API_URL) else { return }
        let parameters: Parameters = ["productId": productId!, "userId": defaults.value(forKey: Keys.id) ?? -1]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductDetailResponse].self) { [weak self] response in
            switch response.result {
            case .success(let details):
                self?.details = details
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

    @objc func handleAddToCart() {
        let isLogged = defaults.value(forKey: Keys.logged) as? Bool
        if isLogged == true {
            if details?[0].isAttribute == true {
                let vc = ProductAttributeViewController()
                vc.productId = productId
                vc.productName = details?[0].name
                vc.productImageUrl = details?[0].images?[0].imageUrl
                
                if details?[0].isSale == 1 {
                    vc.productPrice = details?[0].salePrice
                } else {
                    vc.productPrice = details?[0].price
                }
                
                let nav = UINavigationController(rootViewController: vc)
                DispatchQueue.main.async {
                    self.present(nav, animated: true, completion: nil)
                }
            }
            else {
                addToCart()
            }
        }
        else {
            showLogin()
        }
    }
    
    func showLogin() {
        let loginRegisterViewController = LoginRegisterViewController()
        let navBar = UINavigationController(rootViewController: loginRegisterViewController)
        present(navBar, animated: true, completion: nil)
    }
    
    private func addToCart() {
        guard let url = URL(string: ADD_TO_CART_API_URL) else { return }
        let parameters: Parameters = ["productId": productId!, "userId": defaults.value(forKey: Keys.id)!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseData { [unowned self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                do {
                    // Sử dụng JSONSerialization để chuyển đổi Data thành JSON
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Sử dụng jsonResponse thay vì json
                        if let error = jsonResponse["error"] as? Bool, !error {
                            // Cập nhật số lượng sản phẩm trong giỏ hàng
                            var cartCount = UserDefaults.standard.value(forKey: Keys.cartCount) as? Int ?? 0
                            cartCount += 1
                            UserDefaults.standard.set(cartCount, forKey: Keys.cartCount)
                            self.shoppingCartButton.badge = "\(cartCount)"
                        } else {
                            // Xử lý lỗi nếu có
                            let message = jsonResponse["message"] as? String ?? "Có lỗi xảy ra khi thêm vào giỏ hàng."
                            print(message)
                            // Có thể hiển thị thông báo lỗi cho người dùng ở đây
                        }
                    }
                } catch {
                    print("Lỗi khi phân tích cú pháp JSON: \(error)")
                }
            case .failure(let error):
                print("Lỗi mạng: \(error)")
                // Có thể hiển thị thông báo lỗi hoặc xử lý lỗi ở đây
            }
        }
    }


    @objc func presentCart() {
        let cartViewController = CartViewController()
        let navBar = UINavigationController(rootViewController: cartViewController)
        self.present(navBar, animated: true, completion: nil)
    }

    func presentLoginController() {
        let loginRegisterViewController = LoginRegisterViewController()
        let navBar = UINavigationController(rootViewController: loginRegisterViewController)
        present(navBar, animated: true)
    }

    func presentAllReviewTableViewController(comments: [CommentResponse]) {
        let allReviewTableViewController = AllReviewTableViewController()
        allReviewTableViewController.comments = comments
        let navBar = UINavigationController(rootViewController: allReviewTableViewController)
        DispatchQueue.main.async {
            self.present(navBar, animated: true, completion: nil)
        }
    }
    
    func presentImageViewer(view: GSImageViewerController) {
        DispatchQueue.main.async {
            self.present(view, animated: true, completion: nil)
        }
    }
    
}

// MARK:- Extension
extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductDetailTableViewCell1
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! ProductDetailTableViewCell1
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! ProductDetailTableViewCell2
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! ProductDetailTableViewCell3
        }
        cell.detail = details?[indexPath.section]
        cell.productDetailViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }
    
}
