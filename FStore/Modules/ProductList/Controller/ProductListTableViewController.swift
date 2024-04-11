//
//  ProductListTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import SVProgressHUD
import Alamofire

class ProductListTableViewController: UITableViewController {
    
    // MARK:- Define Variable
    private let cellId = "cellId"
    var categoryId: Int?
    var categoryName: String?
    var trademarkId: Int?
    var trademarkName: String?
    var homeCategoryId: Int?
    var searchText: String?
    var products: [ProductResponse]?
    let defaults = UserDefaults.standard
    
    // MARK:- UI
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.delegate = self
        return sf
    }()
    
    lazy var shoppingCartButton: SSBadgeButton = {
        let b = SSBadgeButton()
        b.frame = CGRect(x: 0, y: 0, width: 44, height: 36)
        b.setImage(#imageLiteral(resourceName: "cart").withRenderingMode(.alwaysTemplate), for: .normal)
        b.badgeFont = UIFont.boldSystemFont(ofSize: 12)
        b.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 10)
        b.badgeBackgroundColor = BADGE_BACKGROUND_COLOR
        b.addTarget(self, action: #selector(presentCart), for: .touchUpInside)
        b.adjustsImageWhenHighlighted = false
        return b
    }()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        fetchData()
    }
    
    @objc private func handleRefresh() {
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cartCount = defaults.value(forKey: Keys.cartCount) as? Int
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
    
    // MARK:- Navigation
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        searchField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
        navigationItem.titleView = searchField
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shoppingCartButton)
    }
    
    @objc private func handleBack() {
        if var controllers = self.navigationController?.viewControllers {
            if controllers.count > 2 {
                controllers.remove(at: controllers.count - 2)
                self.navigationController?.viewControllers = controllers
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:- Fetch Data
    private func fetchData() {
        if categoryId != nil {
            fetchProductsWithCategoryId()
        }
        if searchText != nil {
            fetchProductsWithSearchText()
        }
        if homeCategoryId != nil {
            fetchProductsWithHomeCategoryId()
        }
        if trademarkId != nil {
            fetchProductsWithTrademarkId()
        }
    }
    
    private func fetchProductsWithCategoryId() {
        searchField.attributedPlaceholder = NSAttributedString(string: categoryName ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        guard let url = URL(string: PRODUCT_LIST_API_URL) else { return }
        let parameters: Parameters = ["categoryId": categoryId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
                if self?.refreshControl?.isRefreshing == true {
                    self?.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProductsWithTrademarkId() {
        searchField.attributedPlaceholder = NSAttributedString(string: trademarkName ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        guard let url = URL(string: PRODUCT_LIST_API_URL) else { return }
        let parameters: Parameters = ["trademarkId": trademarkId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
                if self?.refreshControl?.isRefreshing == true {
                    self?.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }

    
    private func fetchProductsWithHomeCategoryId() {
        searchField.attributedPlaceholder = NSAttributedString(string: categoryName ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        guard let url = URL(string: PRODUCT_LIST_API_URL) else { return }
        let parameters: Parameters = ["homeCategoryId": homeCategoryId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
                if self?.refreshControl?.isRefreshing == true {
                    self?.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProductsWithSearchText() {
        searchField.attributedPlaceholder = NSAttributedString(string: searchText ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        guard let url = URL(string: PRODUCT_LIST_API_URL) else { return }
        let parameters: Parameters = ["searchText": searchText!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductResponse].self) { [weak self] response in
            switch response.result {
            case .success(let products):
                self?.products = products
                self?.tableView.reloadData()
                if self?.refreshControl?.isRefreshing == true {
                    self?.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }

    // MARK:- Present CartViewController
    @objc func presentCart() {
        let cartViewController = CartViewController()
        let navBar = UINavigationController(rootViewController: cartViewController)
        self.present(navBar, animated: true, completion: nil)
    }
    
}

// MARK:- Extension
extension ProductListTableViewController: UITextFieldDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductTableViewCell
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let search = SearchViewController()
        search.searchField.text = searchText
        navigationController?.pushViewController(search, animated: false)
    }
    
}
