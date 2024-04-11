//
//  UserTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit

class UserTableViewCell: UITableViewCell {
    
    var isLogged: Bool? {
        didSet {
            if isLogged == true {
                DispatchQueue.main.async {
                    self.configureLogin()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.configureLogout()
                }
            }
        }
    }
    
    let defaults = UserDefaults.standard
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 30
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
    let accountTypeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    let createAtLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        return l
    }()
    
    let welcomeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(white: 0.4, alpha: 1)
        l.text = "Chào mừng bạn đến với FStore"
        return l
    }()
    
    let loginRegisterLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = MAIN_COLOR
        l.text = "Đăng nhập/Đăng ký"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(userImageView)
        userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func configureLogin() {
        removeAll()
        contentView.addSubview(nameLabel)
        nameLabel.text = defaults.value(forKey: Keys.name) as? String
        nameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 16).isActive = true
        
        contentView.addSubview(accountTypeLabel)
        let accountType = defaults.value(forKey: Keys.accountType) as? Int
        if accountType == 0 {
            accountTypeLabel.text = "Tài khoản từ SĐT"
        }
        if accountType == 1 {
            accountTypeLabel.text = "Tài khoản Facebook"
        }
        if accountType == 2 {
            accountTypeLabel.text = "Tài khoản Google"
        }
        if accountType == 3 {
            accountTypeLabel.text = "Tài khoản Twitter"
        }
        accountTypeLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        accountTypeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        contentView.addSubview(createAtLabel)
        let dateString = defaults.value(forKey: Keys.createAt) as? String
        let date = Date()
        let dateFormatter = date.getFormattedDate(string: dateString!)
        createAtLabel.text = "Thành viên từ: \(dateFormatter)"
        createAtLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -2).isActive = true
        createAtLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        if (defaults.value(forKey: Keys.avatarUrl) != nil) {
            let avatarUrl = defaults.value(forKey: Keys.avatarUrl) as? String
            userImageView.sd_setImage(with: URL(string: avatarUrl!), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached, context: nil)
        }
        
    }
    
    func configureLogout() {
        removeAll()
        contentView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 10).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 16).isActive = true

        contentView.addSubview(loginRegisterLabel)
        loginRegisterLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -10).isActive = true
        loginRegisterLabel.leftAnchor.constraint(equalTo: welcomeLabel.leftAnchor).isActive = true
        userImageView.image = #imageLiteral(resourceName: "avatar-default")
    }
    
    func removeAll() {
        nameLabel.removeFromSuperview()
        accountTypeLabel.removeFromSuperview()
        createAtLabel.removeFromSuperview()
        welcomeLabel.removeFromSuperview()
        loginRegisterLabel.removeFromSuperview()
    }
    
}
