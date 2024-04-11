//
//  CategoryTableViewController.swift
//  FStore
//
//  Created by Nguyễn Hải Âu on 2/21/20.
//  Copyright © 2020 Nguyễn Hải Âu. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class CategoryTableViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Danh Mục Sản Phẩm", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.3, alpha: 1)])
        sf.delegate = self
        return sf
    }()
    
    lazy var shoppingCartButton: SSBadgeButton = {
        let b = SSBadgeButton()
        b.setImage(#imageLiteral(resourceName: "cart").withRenderingMode(.alwaysTemplate), for: .normal)
        b.badgeFont = UIFont.boldSystemFont(ofSize: 12)
        b.addTarget(self, action: #selector(presentCart), for: .touchUpInside)
        b.frame = CGRect(x: 0, y: 0, width: 44, height: 36)
        b.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 8)
        b.badgeBackgroundColor = UIColor.orange
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = MAIN_COLOR
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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


class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let cellId = "cellId"
    var categories: [Category]?
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Danh Mục Sản Phẩm", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.3, alpha: 1)])
        sf.delegate = self
        return sf
    }()
    
    lazy var shoppingCartButton: SSBadgeButton = {
        let b = SSBadgeButton()
        b.setImage(#imageLiteral(resourceName: "cart").withRenderingMode(.alwaysTemplate), for: .normal)
        b.badgeFont = UIFont.boldSystemFont(ofSize: 12)
        b.addTarget(self, action: #selector(presentCart), for: .touchUpInside)
        b.frame = CGRect(x: 0, y: 0, width: 44, height: 36)
        b.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 8)
        b.badgeBackgroundColor = UIColor.orange
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        fetchData()
    }
    
    private func fetchData() {
        guard let url = URL(string: CATEGORY_API_URL) else { return }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        Alamofire.request(url).responseJSON { [weak self] (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let categories = try decoder.decode([Category].self, from: data)
                        self?.categories = categories
                        self?.collectionView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    catch let err {
                        print(err)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = MAIN_COLOR
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCollectionViewCell
        cell.category = categories?[indexPath.item]
        cell.categoryCollectionViewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 305)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func showProductList(categoryId: Int, categoryName: String) {
        let layout = UICollectionViewFlowLayout()
        let productListCollectionViewController = ProductListCollectionViewController(collectionViewLayout: layout)
        productListCollectionViewController.categoryId = categoryId
        productListCollectionViewController.categoryName = categoryName
        productListCollectionViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productListCollectionViewController, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tabbar = TabBarController()
        tabbar.selectedIndex = 2
        present(tabbar, animated: false, completion: nil)
    }
    
}

