//
//  SearchViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let defaults = UserDefaults.standard
    private let cellId = "cellId"
    
    lazy var searchField: SearchField = {
        let sf = SearchField()
        sf.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm sản phẩm...", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.4, alpha: 1)])
        sf.delegate = self
        sf.becomeFirstResponder()
        sf.clearButtonMode = UITextField.ViewMode.whileEditing
        return sf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField.becomeFirstResponder()
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        searchField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
        navigationItem.titleView = searchField
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func back() {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: false)
                return
            }
        }
        let tabbarIndex = defaults.value(forKey: Keys.tabbarIndex) as! Int
        tabBarController?.selectedIndex = tabbarIndex
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if !textField.text!.isEmpty {
            let productList = ProductListTableViewController()
            productList.searchText = textField.text
            productList.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productList, animated: true)
        }
        return true
    }
    
}

