//
//  LoginRegisterViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import WMSegmentControl
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD

class LoginRegisterViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    let topView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = MAIN_COLOR
        return v
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 10
        return v
    }()
    
    lazy var segmentControl: WMSegment = {
        let sc = WMSegment()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectorType = SelectorType.bottomBar
        sc.buttonTitles = "ĐĂNG NHẬP, ĐĂNG KÝ"
        sc.textColor = .lightGray
        sc.selectorTextColor = .black
        sc.selectorColor = MAIN_COLOR
        sc.SelectedFont = UIFont.boldSystemFont(ofSize: 14)
        sc.normalFont = UIFont.boldSystemFont(ofSize: 14)
        sc.bottomBarHeight = 2
        return sc
    }()
    
    lazy var loginView: LoginView = {
        let v = LoginView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.loginRegisterViewController = self
        return v
    }()
    
    lazy var registerView: RegisterView = {
        let v = RegisterView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.loginRegisterViewController = self
        return v
    }()
    
    let signupWithSocialLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Hoặc đăng nhập với"
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.spacing = 16
        return sv
    }()
    
    lazy var facebookLoginButton: LoadingButton = {
        let b = LoadingButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysTemplate), for: .normal)
        b.backgroundColor = UIColor(red: 59 / 255, green: 89 / 255, blue: 152 / 255, alpha: 1)
        b.layer.cornerRadius = 22.5
        b.tintColor = .white
        b.adjustsImageWhenHighlighted = false
        b.addTarget(self, action: #selector(handleLoginWithFacebook), for: .touchUpInside)
        return b
    }()
    
    lazy var googleLoginButton: LoadingButton = {
        let b = LoadingButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "google"), for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 22.5
        b.layer.borderWidth = 0.5
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.adjustsImageWhenHighlighted = false
        b.addTarget(self, action: #selector(handleLoginWithGoogle), for: .touchUpInside)
        return b
    }()
    
    lazy var twitterLoginButton: LoadingButton = {
        let b = LoadingButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "twitter").withRenderingMode(.alwaysTemplate), for: .normal)
        b.backgroundColor = UIColor(red: 45 / 255, green: 170 / 255, blue: 226 / 255, alpha: 1)
        b.layer.cornerRadius = 22.5
        b.tintColor = .white
        b.adjustsImageWhenHighlighted = false
        b.addTarget(self, action: #selector(handleLoginWithTwitter), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    
    private func addLoginView() {
        containerView.addSubview(loginView)
        loginView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 44).isActive = true
        loginView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        loginView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        loginView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func addRegisterView() {
        containerView.addSubview(registerView)
        registerView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 44).isActive = true
        registerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        registerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        registerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    var scrollViewBottomConstraint: NSLayoutConstraint!
    
    private func setupViews() {
        view.addSubview(topView)
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2 / 3).isActive = true
        topView.layer.cornerRadius = (view.frame.width * 2) / 2
        topView.layer.masksToBounds = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -107)
        view.addConstraint(scrollViewBottomConstraint)
        
        
        scrollView.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 16).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 40).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        containerViewHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 330)
        view.addConstraint(containerViewHeightConstraint!)
        
        containerView.addSubview(segmentControl)
        segmentControl.backgroundColor = .white
        segmentControl.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: 180).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addLoginView()
        
        segmentControl.onValueChanged = { index in
            if index == 0 {
                UIView.animate(withDuration: 1, animations: {
                    DispatchQueue.main.async {
                        self.registerView.removeFromSuperview()
                        self.addLoginView()
                        self.containerViewHeightConstraint?.constant = 330
                    }
                })
            }
            else {
                UIView.animate(withDuration: 1, animations: {
                    DispatchQueue.main.async {
                        self.loginView.removeFromSuperview()
                        self.containerViewHeightConstraint?.constant = 387
                        self.addRegisterView()
                    }
                })
            }
        }
        
        view.addSubview(stackView)
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 167).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        stackView.addArrangedSubview(facebookLoginButton)
        stackView.addArrangedSubview(googleLoginButton)
        stackView.addArrangedSubview(twitterLoginButton)
        
        view.addSubview(signupWithSocialLabel)
        signupWithSocialLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16).isActive = true
        signupWithSocialLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration) {
                    DispatchQueue.main.async {
                        self.scrollViewBottomConstraint.constant = -(keyboardSize.height)
                        self.scrollView.contentSize.height = 500
                        
                        let bottomOffset = CGPoint(x: 0, y: 16)
                        self.scrollView.setContentOffset(bottomOffset, animated: true)
                        
                        self.view.layoutSubviews()
                    }
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration) {
                DispatchQueue.main.async {
                    self.scrollViewBottomConstraint.constant = -107
                    self.scrollView.contentSize.height = 0
                    self.view.layoutSubviews()
                }
            }
        }
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleLoginWithFacebook() {
        facebookLoginButton.showLoading()
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error == nil {
                let fbLoginResult: LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)! {
                    self.facebookLoginButton.hideLoading()
                    return
                }
                if fbLoginResult.grantedPermissions.contains("email") {
                    self.facebookLoginButton.hideLoading()
                    self.getFBUserData()
                }
            }
        }
    }
    
    private func getFBUserData() {
        if AccessToken.current != nil {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.black)
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (connection, result, error) in
                if error == nil {
                    
                    guard let dict = result as? [String: Any] else { return }
                    let email = dict["email"] as? String
                    let name = dict["name"] as? String
                    let picture = dict["picture"] as? [String: Any]
                    let pictureData = picture?["data"] as? [String: Any]
                    let pictureUrl = pictureData?["url"] as? String
                    self.saveUserDataWithSocial(name: name!, email: email!, accountType: 1, avatarUrl: pictureUrl!)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func saveUserDataWithSocial(name: String, email: String, accountType: Int, avatarUrl: String) {
        guard let url = URL(string: SAVE_USER_DATE_WITH_SOCIAL) else { return }
        let parameters: Parameters = ["name": name, "email": email, "accountType": accountType, "avatarUrl": avatarUrl]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value["error"] as? Bool
                        if error != true {
                            let gender = value.value(forKey: "gender") as? Int
                            let birthday = value.value(forKey: "birthday") as? String
                            
                            self.defaults.set(value.value(forKey: "id"), forKey: Keys.id)
                            self.defaults.set(value.value(forKey: "name"), forKey: Keys.name)
                            self.defaults.set(value.value(forKey: "email"), forKey: Keys.email)
                            self.defaults.set(gender, forKey: Keys.gender)
                            self.defaults.set(value.value(forKey: "accountType"), forKey: Keys.accountType)
                            self.defaults.set(value.value(forKey: "avatarUrl"), forKey: Keys.avatarUrl)
                            self.defaults.set(value.value(forKey: "createAt"), forKey: Keys.createAt)
                            self.defaults.set(birthday, forKey: Keys.birthday)
                            self.defaults.set(value.value(forKey: "cartCount"), forKey: Keys.cartCount)
                            self.defaults.set(value.value(forKey: "addressId"), forKey: Keys.addressId)
                            self.defaults.set(true, forKey: Keys.logged)
                            
                            self.dismiss(animated: true, completion: nil)
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
    
    @objc private func handleLoginWithGoogle() {
        googleLoginButton.showLoading()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc private func handleLoginWithTwitter() {
        showAlert(title: "", message: "Tính năng đang được phát triển")
    }
    
    func showAlert(title: String, message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        alertControl.addAction(closeAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    func showVerificationAlert(title: String, message: String, name: String, password: String, phone: String, accountType: Int) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: .default)
        let verifyAction = UIAlertAction(title: "Xác Minh", style: .default, handler: { (action) in
            self.sendVerificationCode(name: name, password: password, phone: phone, accountType: accountType)
        })
        alertControl.addAction(cancelAction)
        alertControl.addAction(verifyAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showForgotPassword() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        let navBar = UINavigationController(rootViewController: forgotPasswordViewController)
        present(navBar, animated: true, completion: nil)
    }
    
    private func sendVerificationCode(name: String, password: String, phone: String, accountType: Int) {
        guard let url = URL(string: VERIFY_API_URL) else { return }
        let parameters: Parameters = ["phone": phone]
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value.value(forKey: Keys.error) as? Bool
                        if error == true {
                            let message = value.value(forKey: Keys.message) as! String
                            self.showAlert(title: "Có lỗi xảy ra", message: message)
                        } else {
                            let verification = VerificationViewController()
                            verification.name = name
                            verification.password = password
                            verification.phone = phone
                            verification.accountType = accountType
                            verification.type = 0
                            let navBar = UINavigationController(rootViewController: verification)
                            self.present(navBar, animated: true, completion: nil)
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
}

extension LoginRegisterViewController: UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            googleLoginButton.hideLoading()
            return
        }
        
        guard let fullName = user.profile.name else { return }
        guard let email = user.profile.email else { return }
        
        guard let pictureUrl = user.profile.imageURL(withDimension: 100) else { return }
        let pictureString = pictureUrl.absoluteString
        
        self.saveUserDataWithSocial(name: fullName, email: email, accountType: 2, avatarUrl: pictureString)
        googleLoginButton.hideLoading()
        
    }
    
    
}
