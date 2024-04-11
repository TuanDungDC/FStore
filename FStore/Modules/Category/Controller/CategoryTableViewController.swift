//
//  CategoryTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class CategoryTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    var categories: [CategoryResponse]?
    let defaults = UserDefaults.standard
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Danh Mục Sản Phẩm", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        sf.delegate = self
        return sf
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        fetchData()
    }
    
    @objc private func handleRefresh() {
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.set(1, forKey: Keys.tabbarIndex)
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
    
    private func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        searchField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
        navigationItem.titleView = searchField
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shoppingCartButton)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func presentCart() {
        let cartViewController = CartViewController()
        let navBar = UINavigationController(rootViewController: cartViewController)
        self.present(navBar, animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let url = URL(string: CATEGORY_API_URL) else { return }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url).responseDecodable(of: [CategoryResponse].self) { [weak self] response in
            switch response.result {
            case .success(let categories):
                self?.categories = categories
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

    func showProductListController(categoryId: Int, categoryName: String) {
        let productListTableViewController = ProductListTableViewController()
        productListTableViewController.categoryId = categoryId
        productListTableViewController.categoryName = categoryName
        productListTableViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productListTableViewController, animated: true)
    }
    
}

extension CategoryTableViewController: UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryTableViewCell
        cell.category = categories?[indexPath.section]
        cell.categoryTableViewController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return v
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.tabBarController?.selectedIndex = 2
        return false
    }
    
}
