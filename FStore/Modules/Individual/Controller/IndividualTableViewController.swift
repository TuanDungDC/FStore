//
//  IndividualTableViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import SVProgressHUD
import Alamofire

class IndividualTableViewController: UITableViewController {
    
    private let defaults = UserDefaults.standard
    private let userCellId = "userCellId"
    private let cellId = "cellId"
    private let logoutCellId = "logoutCellId"
    var individual: IndividualResponse?
    
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
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: userCellId)
        tableView.register(TDBadgedCell.self, forCellReuseIdentifier: cellId)
        tableView.register(LogoutTableViewCell.self, forCellReuseIdentifier: logoutCellId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defaults.set(4, forKey: Keys.tabbarIndex)
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
        
        fetchData()
        
    }
    
    private func fetchData() {
        guard let url = URL(string: INDIVIDUAL_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id) ?? -1]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Sử dụng AF thay vì Alamofire và response thay cho responseJSON
        AF.request(url, method: .post, parameters: parameters).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        // Giả định rằng IndividualResponse là một kiểu phù hợp với Decodable
                        let individual = try decoder.decode(IndividualResponse.self, from: data)
                        self?.individual = individual
                        self?.tableView.reloadData()
                    } catch let error {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Cá Nhân"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shoppingCartButton)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func presentCart() {
        let cartViewController = CartViewController()
        let navBar = UINavigationController(rootViewController: cartViewController)
        present(navBar, animated: true, completion: nil)
    }
    
    func presentLogin() {
        let loginRegisterViewController = LoginRegisterViewController()
        let navBar = UINavigationController(rootViewController: loginRegisterViewController)
        DispatchQueue.main.async {
            self.present(navBar, animated: true, completion: nil)
        }
    }
    
}

extension IndividualTableViewController: UIGestureRecognizerDelegate {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let isLogged = defaults.value(forKey: Keys.logged) as? Bool
        if isLogged  == true {
            return 4
        }
        else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 4
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let logged = defaults.value(forKey: Keys.logged) as? Bool
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as! UserTableViewCell
            cell.isLogged = defaults.value(forKey: Keys.logged) as? Bool
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TDBadgedCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "Đơn hàng đang xử lý"
                if logged != nil {
                    if let pending = individual?.pending {
                        if pending != 0 {
                            cell.badgeString = "\(pending)"
                        }
                        else {
                            cell.badgeString = ""
                        }
                    }
                }
                else {
                    cell.badgeString = ""
                }
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "Đơn hàng đang giao"
                if logged != nil {
                    if let shipping = individual?.shipping {
                        if shipping != 0 {
                            cell.badgeString = "\(shipping)"
                        }
                        else {
                            cell.badgeString = ""
                        }
                    }
                }
                else {
                    cell.badgeString = ""
                }
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = "Đơn hàng thành công"
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = "Đơn hàng đã huỷ"
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.badgeColor = BADGE_BACKGROUND_COLOR
            cell.badgeColorHighlighted = BADGE_BACKGROUND_COLOR
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TDBadgedCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "Sản phẩm đã mua"
            }
            
            if indexPath.row == 1 {
                cell.textLabel?.text = "Sản phẩm yêu thích"
            }
            
            if indexPath.row == 2 {
                cell.textLabel?.text = "Đánh giá sản phẩm đã mua"
                if logged != nil {
                    if let purchased = individual?.purchased {
                        if purchased != 0 {
                            cell.badgeString = "\(purchased)"
                        }
                        else {
                            cell.badgeString = ""
                        }
                    }
                }
                else {
                    cell.badgeString = ""
                }
            }
            
            if indexPath.row == 3 {
                cell.textLabel?.text = "Sản phẩm đã đánh giá"
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.badgeColor = BADGE_BACKGROUND_COLOR
            cell.badgeColorHighlighted = BADGE_BACKGROUND_COLOR
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: logoutCellId, for: indexPath) as! LogoutTableViewCell
            cell.individualTableViewController = self
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
        switch indexPath.section {
        case 0:
            return 100
        case 3:
            return 60
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (defaults.value(forKey: Keys.logged) == nil) {
            presentLogin()
        }
        else {
            if indexPath.section == 0 {
                let profile = ProfileTableViewController(style: .grouped)
                profile.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(profile, animated: true)
            }
            if indexPath.section == 1 {
                let orderTableViewController = OrderTableViewController()
                orderTableViewController.orderStatus = indexPath.row + 1
                orderTableViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(orderTableViewController, animated: true)
            }
            if indexPath.section == 2 {
                if indexPath.row == 0 {
                    let productPurchasedTableViewController = ProductPurchasedTableViewController()
                    productPurchasedTableViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(productPurchasedTableViewController, animated: true)
                }
                if indexPath.row == 1 {
                    let productFavouriteTableViewController = ProductFavouriteTableViewController()
                    productFavouriteTableViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(productFavouriteTableViewController, animated: true)
                }
                if indexPath.row == 2 {
                    let productReviewTableViewController = ProductReviewTableViewController()
                    productReviewTableViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(productReviewTableViewController, animated: true)
                }
                if indexPath.row == 3 {
                    let ratedProductTableViewController = RatedProductTableViewController()
                    ratedProductTableViewController.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(ratedProductTableViewController, animated: true)
                }
            }
        }
    }
    
}
