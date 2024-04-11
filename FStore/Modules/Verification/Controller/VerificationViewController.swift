//
//  VerificationViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import KWVerificationCodeView
import Alamofire
import SVProgressHUD

class VerificationViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var name: String?
    var password: String?
    var phone: String?
    var accountType: Int?
    var type: Int? // Dùng để phân biệt gửi mã kích hoạt tài khoản hay cập nhật lại mật khẩu hoặc thay đổi số điện thoại
    
    var countdownTimer: Timer?
    var totalTime = 30
    
    let notificationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.text = "Mã xác thực đã được gửi đến số điện thoại của bạn. 1 số điện thoại được gửi tối đa 3 mã xác thực trong 1 ngày."
        return l
    }()
    
    let phoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 18)
        return l
    }()
    
    lazy var VerificationView: KWVerificationCodeView = {
        let v = KWVerificationCodeView(frame: CGRect(x: 0, y: 0, width: 240, height: 60))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.digits = 6
        v.focus()
        v.isTappable = true
        v.underlineColor = .lightGray
        v.underlineSelectedColor = MAIN_COLOR
        v.textColor = MAIN_COLOR
        v.textFieldTintColor = .clear
        return v
    }()
    
    lazy var activeButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.backgroundColor = .red
        return b
    }()
    
    lazy var sendAgainButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Gửi lại", for: .normal)
        b.setTitleColor(MAIN_COLOR, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.addTarget(self, action: #selector(handleSendAgain), for: .touchUpInside)
        b.sizeToFit()
        return b
    }()
    
    let timerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .center
        l.textColor = MAIN_COLOR
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phone!)
        view.backgroundColor = .white
        setupNavBar()
        view.addSubview(notificationLabel)
        notificationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 16).isActive = true
        phoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneLabel.text = phone!
        
        view.addSubview(VerificationView)
        VerificationView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 16).isActive = true
        VerificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        VerificationView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        VerificationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(activeButton)
        activeButton.topAnchor.constraint(equalTo: VerificationView.bottomAnchor, constant: 16).isActive = true
        activeButton.leftAnchor.constraint(equalTo: notificationLabel.leftAnchor).isActive = true
        activeButton.rightAnchor.constraint(equalTo: notificationLabel.rightAnchor).isActive = true
        activeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        if type == 0 {
            activeButton.setTitle("Kích Hoạt", for: .normal)
            activeButton.addTarget(self, action: #selector(activeAndCreateUser), for: .touchUpInside)
        }
        
        if type == 1 {
            activeButton.setTitle("Tiếp Tục", for: .normal)
            activeButton.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        }
        
        if type == 2 {
            activeButton.setTitle("Kích Hoạt", for: .normal)
            activeButton.addTarget(self, action: #selector(handleUpdatePhoneNumber), for: .touchUpInside)
        }
        
        
        view.addSubview(sendAgainButton)
        sendAgainButton.centerXAnchor.constraint(equalTo: activeButton.centerXAnchor).isActive = true
        sendAgainButton.topAnchor.constraint(equalTo: activeButton.bottomAnchor, constant: 16).isActive = true
        sendAgainButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        view.addSubview(timerLabel)
        timerLabel.centerYAnchor.constraint(equalTo: sendAgainButton.centerYAnchor).isActive = true
        timerLabel.leftAnchor.constraint(equalTo: sendAgainButton.rightAnchor, constant: 4).isActive = true
        timerLabel.isHidden = true
    }
    
    private func startTimer() {
        sendAgainButton.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func endTimer() {
        timerLabel.isHidden = true
        countdownTimer?.invalidate()
        sendAgainButton.isUserInteractionEnabled = true
        totalTime = 30
    }
    
    @objc func updateTime() {
        timerLabel.isHidden = false
        if totalTime != 0 {
            totalTime -= 1
        }
        else {
            endTimer()
        }
        timerLabel.text = "(\(totalTime) s)"
    }

    @objc func handleSendAgain() {
        sendVerificationCode(phone: phone!)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Nhập Mã Xác Thực"
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    @objc private func handleResetPassword() {
        guard let url = URL(string: RESET_PASSWORD_API_URL) else { return }
        let parameters: Parameters = ["phone": phone!, "code": VerificationView.getVerificationCode()]
        AF.request(url, method: .post, parameters: parameters).response { [unowned self] response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let error = jsonData.value(forKey: Keys.error) as? Bool
                        if error == true {
                            let message = jsonData.value(forKey: Keys.message) as! String
                            self.showAlert(title: "Có lỗi xảy ra", message: message)
                        } else {
                            let updatePasswordViewController = UpdatePasswordViewController()
                            updatePasswordViewController.phone = self.phone!
                            self.navigationController?.pushViewController(updatePasswordViewController, animated: true)
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc private func handleUpdatePhoneNumber() {
        guard let url = URL(string: UPDATE_PHONE_NUMBER_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "phone": phone!, "code": VerificationView.getVerificationCode()]
        AF.request(url, method: .post, parameters: parameters).response { [unowned self] response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let error = jsonData["error"] as? Bool
                        if error == false {
                            self.updateUI()
                        } else {
                            let message = jsonData["message"] as? String
                            self.showAlert(title: "Có lỗi xảy ra", message: message!)
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveUser(_ user: UserResponse) {
        defaults.set(user.id, forKey: Keys.id)
        defaults.set(user.name, forKey: Keys.name)
        defaults.set(user.phone, forKey: Keys.phone)
        defaults.set(user.email, forKey: Keys.email)
        defaults.set(user.gender, forKey: Keys.gender)
        defaults.set(user.avatarUrl, forKey: Keys.avatarUrl)
        defaults.set(user.birthday, forKey: Keys.birthday)
        
        self.showAlertWithAction(title: "Thành Công", message: "Thay đổi số điện thoại thành công")
        
    }
    
    func updateUI() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        guard let url = URL(string: GET_USER_INFO) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserResponse.self) { [weak self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let user):
                self?.saveUser(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func sendVerificationCode(phone: String) {
        guard let url = URL(string: VERIFY_API_URL) else { return }
        let parameters: Parameters = ["phone": phone]
        AF.request(url, method: .post, parameters: parameters).response { [unowned self] response in
            switch response.result {
            case .success(let data):
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let error = jsonData.value(forKey: Keys.error) as? Bool
                        if error == true {
                            let message = jsonData.value(forKey: Keys.message) as! String
                            self.showAlert(title: "Có lỗi xảy ra", message: message)
                        } else {
                            self.startTimer()
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    private func showAlertWithAction(title: String, message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    @objc private func activeAndCreateUser() {
        guard let url = URL(string: USER_VERIFICATION_AND_REGISTER_API_URL) else { return }
        let parameters: Parameters = ["phone": phone!, "code": VerificationView.getVerificationCode(), "name": name!, "password": password!, "accountType": accountType!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { [unowned self] response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value.value(forKey: Keys.error) as! Bool
                        if error {
                            let message = value.value(forKey: Keys.message) as! String
                            self.showAlert(title: "Có lỗi xảy ra", message: message)
                        } else {
                            self.defaults.set(value.value(forKey: Keys.id), forKey: Keys.id)
                            self.defaults.set(value.value(forKey: Keys.name), forKey: Keys.name)
                            self.defaults.set(value.value(forKey: Keys.phone), forKey: Keys.phone)
                            self.defaults.set(value.value(forKey: Keys.accountType), forKey: Keys.accountType)
                            self.defaults.set(value.value(forKey: Keys.avatarUrl), forKey: Keys.avatarUrl)
                            self.defaults.set(value.value(forKey: Keys.createAt), forKey: Keys.createAt)
                            self.defaults.set(true, forKey: Keys.logged)
                            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                } catch {
                    print(error)
                }
            } else if let error = response.error {
                print(error)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
