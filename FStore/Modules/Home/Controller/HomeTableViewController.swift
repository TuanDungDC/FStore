//
//  HomeTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import SVProgressHUD
import Alamofire

class HomeTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    private let headerCellId = "headerCellId"
    let defaults = UserDefaults.standard
    var homeResponses: [HomeResponse]?
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Bạn tìm gì hôm nay?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
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
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(HeaderHomeTableViewCell.self, forCellReuseIdentifier: headerCellId)
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.set(0, forKey: Keys.tabbarIndex)
        
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
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleRefresh() {
        self.fetchData()
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
    
    func showProductListController(categoryId: Int, categoryName: String) {
        let productListTableViewController = ProductListTableViewController()
        productListTableViewController.homeCategoryId = categoryId
        productListTableViewController.categoryName = categoryName
        productListTableViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productListTableViewController, animated: true)
    }
    
    private func fetchData() {
        guard let url = URL(string: HOME_API_URL) else { return }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url).responseDecodable(of: [HomeResponse].self) { [weak self] response in
            switch response.result {
            case .success(let homeResponses):
                self?.homeResponses = homeResponses
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
    
    func showDetailViewController(productId: Int) {
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.productId = productId
        productDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
}


extension HomeTableViewController: UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return homeResponses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! HeaderHomeTableViewCell
            cell.homeResponse = homeResponses?[indexPath.section]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeTableViewCell
            cell.homeResponse = homeResponses?[indexPath.section]
            cell.homeTableViewController = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
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
