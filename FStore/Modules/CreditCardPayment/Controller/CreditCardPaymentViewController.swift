//
//  CreditCardPaymentViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Stripe
import CreditCardForm
import Alamofire
import SVProgressHUD

class CreditCardPaymentViewController: UIViewController {
    
    var amount: Float?
    var fee: Float?
    var totalPrice: Float?
    var paymentIntentClientSecret: String?
    var defaults = UserDefaults.standard
    
    var paymentTextField: STPPaymentCardTextField = {
        let tf = STPPaymentCardTextField()
        return tf
    }()
    
    var creditCardFormView: CreditCardFormView = {
        let v = CreditCardFormView()
        return v
    }()
    
    lazy var payButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        return b
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavBar()
        
        creditCardFormView.frame = CGRect(x: 10, y: 100, width: 300, height: 200)
        creditCardFormView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditCardFormView)
        
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        paymentTextField.delegate = self
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        view.addSubview(paymentTextField)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.layer.cornerRadius = 5
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        payButton.setTitle("Thanh Toán", for: .normal)
        payButton.clipsToBounds = true
        payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        bottomView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            creditCardFormView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            creditCardFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creditCardFormView.widthAnchor.constraint(equalToConstant: 300),
            creditCardFormView.heightAnchor.constraint(equalToConstant: 200),
            
            paymentTextField.topAnchor.constraint(equalTo: creditCardFormView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 93),
            
            payButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16),
            payButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -28.5),
            payButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        startCheckout()
        
    }
    
    private func setupNavBar() {
        navigationItem.title = "Thanh Toán Đơn Hàng"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-back"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func startCheckout() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        let vndToDolar: Double = Double(totalPrice!) / Double(23282)
        let dolarFormat = round(vndToDolar * 100)
        
        let parameters: [String: Any] = ["amount": dolarFormat, "currency": "usd", "customerId": "cus_HNBqECJxDRTWc1"]
        
        // Sử dụng AF thay vì Alamofire và response thay cho responseJSON
        AF.request(URL(string: BASE_URL + "stripebackend/createpaymentintent.php")!, method: .post, parameters: parameters, encoding: URLEncoding.default).response { [weak self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        // Chuyển đổi dữ liệu nhận được thành dictionary hoặc array
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let clientSecret = json["clientSecret"] as? String
                            self?.paymentIntentClientSecret = clientSecret
                        }
                    } catch let error {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if restartDemo {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayAlert2(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Thanh toán", style: .default) { _ in
                self.paymentProgress()
            })
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func pay() {
        let priceFormatter = totalPrice?.numberFormatter()
        displayAlert2(title: "Thông báo", message: "Bạn có muốn thanh toán cho đơn hàng này với số tiền \(priceFormatter!) ₫")
    }
    
    private func paymentProgress() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return
        }
        // Collect card details
        let cardParams = paymentTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            SVProgressHUD.dismiss()
            switch (status) {
            case .failed:
                self.displayAlert(title: "Lỗi", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                self.submitOrderToServer()
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func submitOrderToServer() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        guard let url = URL(string: ORDER_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "amount": amount!, "fee": fee!, "totalPrice": totalPrice!, "shippingMethod": defaults.value(forKey: Keys.shippingMethodId)!, "paymentMethod": defaults.value(forKey: Keys.paymentMethodId)!]
        
        // Sử dụng AF thay vì Alamofire và response thay cho responseJSON
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).response { [weak self] response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        // Chuyển đổi dữ liệu nhận được thành dictionary hoặc array
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let error = json["error"] as? Int
                            let orderId = json["orderId"] as? Int
                            if error == 0 {
                                let success = OrderSuccessViewController()
                                success.price = self?.totalPrice
                                success.payment = true
                                success.orderId = orderId
                                let nav = UINavigationController(rootViewController: success)
                                DispatchQueue.main.async {
                                    self?.present(nav, animated: true, completion: nil)
                                }
                            }
                        }
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
    
}

extension CreditCardPaymentViewController: STPPaymentCardTextFieldDelegate, STPAuthenticationContext {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
}
