//
//  LogoutTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD

class LogoutTableViewCell: UITableViewCell {
    
    private let defaults = UserDefaults.standard
    var individualTableViewController: IndividualTableViewController?
    
    lazy var logoutButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Đăng Xuất", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.tintColor = MAIN_COLOR
        b.backgroundColor = .white
        b.layer.borderColor = MAIN_COLOR.cgColor
        b.layer.borderWidth = 1
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(logoutButton)
        logoutButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLogout() {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Set nil for UserDefault
        self.defaults.set(nil, forKey: Keys.logged)
        self.defaults.set(nil, forKey: Keys.id)
        self.defaults.set(nil, forKey: Keys.name)
        self.defaults.set(nil, forKey: Keys.phone)
        self.defaults.set(nil, forKey: Keys.email)
        self.defaults.set(nil, forKey: Keys.gender)
        self.defaults.set(nil, forKey: Keys.accountType)
        self.defaults.set(nil, forKey: Keys.avatarUrl)
        self.defaults.set(nil, forKey: Keys.createAt)
        self.defaults.set(nil, forKey: Keys.birthday)
        self.defaults.set(nil, forKey: Keys.cartCount)
        self.defaults.set(nil, forKey: Keys.addressId)
        
        // Facebook logout
        if AccessToken.current != nil {
            let loginManager = LoginManager()
            loginManager.logOut()
        }
        
        // Google sign out
        if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
            GIDSignIn.sharedInstance()?.signOut()
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.individualTableViewController?.tableView.reloadData()
            self.individualTableViewController?.tableView.layoutIfNeeded()
            self.individualTableViewController?.view.layoutIfNeeded()
            self.individualTableViewController?.shoppingCartButton.badge = nil
            SVProgressHUD.dismiss()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //Get the width of tableview
        let width = subviews[0].frame.width

        for view in subviews where view != contentView {
            //for top and bottom separator will be same width with the tableview width
            //so we check at here and remove accordingly
            if view.frame.width == width {
                view.removeFromSuperview()
            }
        }
    }
    
}
