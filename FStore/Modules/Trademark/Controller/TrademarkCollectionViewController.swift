//
//  TrademarkCollectionViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import SVProgressHUD
import Alamofire

class TrademarkCollectionViewController: UICollectionViewController {
    
    private let cellId = "cellId"
    let defaults = UserDefaults.standard
    var trademarkes: [TrademarkResponse]?
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Thương Hiệu", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
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
        setupCollectionView()
        setupNavBar()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.set(3, forKey: Keys.tabbarIndex)
        
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
    
    private func fetchData() {
        guard let url = URL(string: TRADEMARK_API_URL) else { return }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url).response { [weak self] response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let trademarkes = try decoder.decode([TrademarkResponse].self, from: data)
                    self?.trademarkes = trademarkes
                    self?.collectionView.reloadData()
                    if self?.collectionView.refreshControl?.isRefreshing == true {
                        self?.collectionView.refreshControl?.endRefreshing()
                    }
                } catch let err {
                    print(err)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(TrademarkCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        collectionView.refreshControl = UIRefreshControl()
        
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        fetchData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        searchField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
        navigationItem.titleView = searchField
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shoppingCartButton)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func presentCart() {
        let cartViewController = CartViewController()
        let navBar = UINavigationController(rootViewController: cartViewController)
        self.present(navBar, animated: true, completion: nil)
    }
    
    
}


extension TrademarkCollectionViewController: UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trademarkes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 12
        return CGSize(width: width, height: width - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrademarkCollectionViewCell
        cell.trademark = trademarkes?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productList = ProductListTableViewController()
        productList.trademarkId = trademarkes?[indexPath.item].id
        productList.trademarkName = trademarkes?[indexPath.item].name
        productList.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(productList, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.tabBarController?.selectedIndex = 2
        return false
    }
    
}
