//
//  ProductAttributeViewController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Alamofire
import SVProgressHUD

class ProductAttributeViewController: UIViewController {
    
    private let cellId = "cellId"
    var productId: Int? // nhận productId từ produdt detail
    var productName: String? // nhận productName từ produdt detail
    var productImageUrl: String? // nhận productImageUrl từ produdt detail
    var productPrice: Float? // nhận productPrice từ produdt detail
    var attributes: [ProductAttributeResponse]?
    var attributeId: Int? // lưu lại id thuộc tính
    var defaults = UserDefaults.standard
    
    let topView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 2
        return l
    }()
    
    let attributeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Thuộc tính:"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = UIColor(white: 0.2, alpha: 1)
        return l
    }()
    
    let attributeValueLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Chưa Chọn"
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let bottomView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return v
    }()
    
    lazy var addToCartButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Thêm Vào Giỏ Hàng", for: .normal)
        b.tintColor = .white
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        configureTopView()
        configureBottomView()
        configureCollectionView()
        fetchData()
    }
    
    @objc private func handleAddToCart() {
        guard let url = URL(string: ADD_TO_CART_API_URL),
              let productId = productId,
              let userId = defaults.value(forKey: Keys.id) as? String,
              let attributeId = attributeId else {
            SVProgressHUD.showError(withStatus: "Invalid parameters or URL")
            return
        }
        let parameters: Parameters = ["productId": productId, "userId": userId, "attributeId": attributeId]

        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: ProductAttributeResponse.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(_):
                    var cartCount = UserDefaults.standard.value(forKey: Keys.cartCount) as? Int ?? 0
                    cartCount += 1
                    UserDefaults.standard.set(cartCount, forKey: Keys.cartCount)
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
                }
            }
        }
    }
//    private func fetchData() {
//        guard let url = URL(string: PRODUCT_ATTRIBUTE_API_URL) else { return }
//        let parameters: Parameters = ["productId": productId!]
//        
//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultMaskType(.black)
//        
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
//            switch response.result {
//            case .success(let data):
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    do {
//                        let attributes = try decoder.decode([ProductAttributeResponse].self, from: data)
//                        self.attributes = attributes
//                        self.collectionView.reloadData()
//                        SVProgressHUD.dismiss()
//                    } catch {
//                        SVProgressHUD.showError(withStatus: "Error: \(error.localizedDescription)")
//                    }
//                } else {
//                    SVProgressHUD.showError(withStatus: "No data received from the server.")
//                }
//            case .failure(let error):
//                SVProgressHUD.showError(withStatus: "Request failed: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func fetchData() {
        guard let url = URL(string: PRODUCT_ATTRIBUTE_API_URL) else { return }
        let parameters: Parameters = ["productId": productId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductAttributeResponse].self) { [weak self] response in
            switch response.result {
            case .success(let attributes):
                self?.attributes = attributes
                self?.collectionView.reloadData()
                if self?.collectionView.refreshControl?.isRefreshing == true {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        collectionView.register(ProductAttributeCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        bottomView.addSubview(addToCartButton)
        addToCartButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 16).isActive = true
        addToCartButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -16).isActive = true
        addToCartButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -32).isActive = true
        addToCartButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addToCartButton.isUserInteractionEnabled = false
        addToCartButton.alpha = 0.5
    }
    
    private func configureTopView() {
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        topView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.sd_setImage(with: URL(string: productImageUrl!)!, placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached, context: nil)
        
        topView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16).isActive = true
        nameLabel.text = productName!
        
        topView.addSubview(attributeLabel)
        attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        attributeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        topView.addSubview(attributeValueLabel)
        attributeValueLabel.centerYAnchor.constraint(equalTo: attributeLabel.centerYAnchor).isActive = true
        attributeValueLabel.leftAnchor.constraint(equalTo: attributeLabel.rightAnchor, constant: 8).isActive = true
        
        topView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        let priceFormatter = productPrice?.numberFormatter()
        priceLabel.text = priceFormatter! + " ₫"
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        navigationItem.title = "Lựa Chọn Thuộc Tính"
        self.navigationItem.hidesBackButton = true
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismiss))
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProductAttributeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attributes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductAttributeCollectionViewCell
        cell.attribute = attributes?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 16
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.dismiss(withDelay: 0.3) { [unowned self] in
            self.attributeId = self.attributes?[indexPath.item].attributeId
            self.attributeValueLabel.text = self.attributes?[indexPath.item].attributeName
            self.addToCartButton.isUserInteractionEnabled = true
            self.addToCartButton.alpha = 1
        }
    }
    
}
