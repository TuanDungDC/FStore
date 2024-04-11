//
//  WriteReviewProductViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit
import Cosmos
import RSKPlaceholderTextView
import Alamofire
import SVProgressHUD

class WriteReviewProductViewController: UIViewController, UITextViewDelegate {
    
    var productId: Int?
    var orderId: Int?
    var productImageUrl: String?
    var productName: String?
    let defaults = UserDefaults.standard
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        sv.contentSize.height = 550
        return sv
    }()
    
    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let dividerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return v
    }()
    
    let ratingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Vui lòng đánh giá"
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textAlignment = .center
        return l
    }()
    
    let ratingView: CosmosView = {
        let v = CosmosView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.settings.starSize = 44
        v.settings.starMargin = 12
        v.settings.totalStars = 5
        v.settings.filledImage = #imageLiteral(resourceName: "gold-star")
        v.settings.emptyImage = #imageLiteral(resourceName: "darkgray-star")
        v.settings.fillMode = StarFillMode.full
        v.rating = 0
        return v
    }()
    
    let notificationLabel1: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .red
        return l
    }()
    
    let notificationLabel2: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .red
        return l
    }()
    
    lazy var commentTextView: RSKPlaceholderTextView = {
        let tv = RSKPlaceholderTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholder = "Hãy chia sẻ đánh giá, cảm nhận của bạn về sản phẩm này!"
        tv.placeholderColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 4
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.clipsToBounds = true
        tv.autocorrectionType = .no
        tv.returnKeyType = UIReturnKeyType.done
        tv.delegate = self
        return tv
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()

    lazy var sendButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Gửi", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.backgroundColor = MAIN_COLOR
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupBottomView()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    var scrollViewBottomLayoutConstraint: NSLayoutConstraint?
    
    var bottomViewLayoutConstraint: NSLayoutConstraint?
    
    private func setupBottomView() {
        view.addSubview(bottomView)
        bottomViewLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomViewLayoutConstraint!)
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        bottomView.addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        sendButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollViewBottomLayoutConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: 0)
        view.addConstraint(scrollViewBottomLayoutConstraint!)
        
        scrollView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        productImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        productImageView.sd_setImage(with: URL(string: productImageUrl!), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
        
        scrollView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        nameLabel.text = productName!
        
        scrollView.addSubview(dividerView)
        dividerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        dividerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        dividerView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        scrollView.addSubview(ratingLabel)
        ratingLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 24).isActive = true
        ratingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        ratingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(ratingView)
        ratingView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        ratingView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 268).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        ratingView.didTouchCosmos = { rating in
            self.notificationLabel1.text = nil
            if rating == 1 {
                DispatchQueue.main.async {
                    self.ratingLabel.text = "Rất không hài lòng"
                }
            }
            if rating == 2 {
                DispatchQueue.main.async {
                    self.ratingLabel.text = "Không hài lòng"
                }
            }
            if rating == 3 {
                DispatchQueue.main.async {
                    self.ratingLabel.text = "Bình thường"
                }
            }
            if rating == 4 {
                DispatchQueue.main.async {
                    self.ratingLabel.text = "Hài lòng"
                }
            }
            if rating == 5 {
                DispatchQueue.main.async {
                    self.ratingLabel.text = "Cực kì hài lòng"
                }
            }
        }
        
        scrollView.addSubview(notificationLabel1)
        notificationLabel1.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16).isActive = true
        notificationLabel1.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
        
        scrollView.addSubview(commentTextView)
        commentTextView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 60).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        commentTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(notificationLabel2)
        notificationLabel2.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 16).isActive = true
        notificationLabel2.leftAnchor.constraint(equalTo: commentTextView.leftAnchor).isActive = true
        
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration) {
                    self.bottomViewLayoutConstraint?.constant = -(keyboardSize.height)
                    
                    let bottomOffset = CGPoint(x: 0, y: keyboardSize.height + 40)
                    self.scrollView.setContentOffset(bottomOffset, animated: true)
                    
                    self.view.layoutSubviews()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration) {
                self.bottomViewLayoutConstraint?.constant = 0
                self.view.layoutSubviews()
            }
        }
    }
    
    @objc func handleSend() {
        if ratingView.rating == 0 {
            notificationLabel1.text = "Bạn cần đánh giá trước khi gửi."
        }
        let textCount = (commentTextView.text as NSString).length
        if textCount < 30 {
            notificationLabel2.text = "Bạn cần chia sẻ ít nhất 30 kí tự."
        }
        if ratingView.rating != 0 && textCount >= 30 {
            self.sendRating()
        }
    }
    
    private func sendRating() {
        guard let url = URL(string: REVIEW_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "rating": ratingView.rating, "comment": commentTextView.text!, "productId": productId!, "orderId": orderId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Cập nhật cú pháp yêu cầu Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            SVProgressHUD.dismiss()
            if let data = response.data {
                do {
                    if let value = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        let error = value["error"] as? Bool
                        if error == false {
                            let message = value["message"] as? String
                            let alertController = UIAlertController(title: "Đã đánh giá", message: message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                                self?.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
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

    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Viết Đánh Giá"
    }

    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notificationLabel2.text = nil
    }
    
}
