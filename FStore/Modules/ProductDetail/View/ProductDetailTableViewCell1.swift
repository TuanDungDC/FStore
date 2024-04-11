//
//  ProductDetailTableViewCell1.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit
import Cosmos
import Alamofire
import SVProgressHUD
import GSImageViewerController

class ProductDetailTableViewCell1: UITableViewCell {
    
    var detail: ProductDetailResponse? {
        didSet {
            
            collectionView.reloadData()
            
            
            if let pageNumber = detail?.images?.count {
                if pageNumber == 1 {
                    pageControl.isHidden = true
                }
                else {
                    pageControl.numberOfPages = pageNumber
                }
            }
            
            if let name = detail?.name {
                nameLabel.text = name
            }
            
            if detail?.isSale == 1 {
                guard let price = detail?.salePrice else { return }
                let priceFormatter = price.numberFormatter()
                guard let originPrice = detail?.price else { return }
                let originPriceFormatter = originPrice.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.attributedText = (originPriceFormatter + " ₫").strikeThrough()
            }
            else {
                guard let price = detail?.price else { return }
                let priceFormatter = price.numberFormatter()
                priceLabel.text = priceFormatter + " ₫"
                originPriceLabel.text = ""
            }
            
            if let rating = detail?.rating {
                ratingView.isHidden = false
                ratingView.rating = Double(rating)
            }
            else {
                noRatingLabel.isHidden = false
                noRatingLabel.text = "chưa có đánh giá"
            }
            
            if let comment = detail?.comment {
                if comment > 0 {
                    totalCommentLabel.isHidden = false
                    totalCommentLabel.text = "(\(comment) đánh giá)"
                }
            }
            
            if let favourite = detail?.isFavourite {
                if favourite == true {
                    favouriteButton.setImage(#imageLiteral(resourceName: "favourite-selected").withRenderingMode(.alwaysTemplate), for: .normal)
                    favouriteButton.tintColor = MAIN_COLOR
                }
                else {
                    favouriteButton.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
                }
            }
        }
    }
    
    var productDetailViewController: ProductDetailViewController?
    
    let defaults = UserDefaults.standard
    private let cellId = "cellId"
    private let tableViewCellId = "tableViewCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = MAIN_COLOR
        pc.pageIndicatorTintColor = .lightGray
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.numberOfLines = 0
        return l
    }()
    
    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        return l
    }()
    
    let originPriceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    let ratingView: CosmosView = {
        let v = CosmosView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.settings.updateOnTouch = false
        v.settings.starSize = 15
        v.settings.starMargin = 2
        v.settings.totalStars = 5
        v.settings.filledImage = #imageLiteral(resourceName: "gold-star")
        v.settings.emptyImage = #imageLiteral(resourceName: "darkgray-star")
        v.settings.fillMode = StarFillMode.half
        v.rating = 0
        return v
    }()
    
    let totalCommentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .black
        return l
    }()
    
    lazy var favouriteButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "favourite"), for: .normal)
        b.addTarget(self, action: #selector(handleFavourite), for: .touchUpInside)
        return b
    }()
    
    let noRatingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    lazy var buyButton: GradientButton = {
        let b = GradientButton(gradientColors: [FIRST_GRADIENT_COLOR, SECOND_GRADIENT_COLOR], startPoint: .bottomLeft, endPoint: .topRight)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Thêm Vào Giỏ Hàng", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.tintColor = .white
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleAddToCart() {
        self.productDetailViewController?.handleAddToCart()
    }
    
    @objc func handleFavourite() {
        if favouriteButton.currentImage == UIImage(named: "favourite") {
            addFavourite()
        }
        else {
            removeFavourite()
        }
    }
    
    private func addFavourite() {
        if (defaults.value(forKey: Keys.id) == nil) {
            productDetailViewController?.showLogin()
            return
        }
        
        guard let url = URL(string: ADD_FAVOURITE_PRODUCT_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "productId": productDetailViewController!.productId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseData { [unowned self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let error = jsonResponse["error"] as? Bool, !error {
                        self.favouriteButton.setImage(#imageLiteral(resourceName: "favourite-selected").withRenderingMode(.alwaysTemplate), for: .normal)
                        self.favouriteButton.tintColor = MAIN_COLOR
                    } else {
                        // Handle the error case
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func removeFavourite() {
        guard let url = URL(string: REMOVE_FAVOURITE_PRODUCT_API_URL) else { return }
        let parameters: Parameters = ["userId": defaults.value(forKey: Keys.id)!, "productId": productDetailViewController!.productId!]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        AF.request(url, method: .post, parameters: parameters).responseData { [unowned self] response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let data):
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let error = jsonResponse["error"] as? Bool, !error {
                        self.favouriteButton.setImage(#imageLiteral(resourceName: "favourite").withRenderingMode(.alwaysTemplate), for: .normal)
                    } else {
                        // Handle the error case
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func setupViews() {
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        
        contentView.addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -24).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        contentView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        contentView.addSubview(originPriceLabel)
        originPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2).isActive = true
        originPriceLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor).isActive = true
        
        contentView.addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: originPriceLabel.bottomAnchor, constant: 8).isActive = true
        ratingView.leftAnchor.constraint(equalTo: originPriceLabel.leftAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ratingView.isHidden = true
        
        contentView.addSubview(buyButton)
        buyButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 24).isActive = true
        buyButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        buyButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        contentView.addSubview(totalCommentLabel)
        totalCommentLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        totalCommentLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8).isActive = true
        totalCommentLabel.isHidden = true
        
        contentView.addSubview(favouriteButton)
        favouriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        favouriteButton.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        contentView.addSubview(noRatingLabel)
        noRatingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        noRatingLabel.leftAnchor.constraint(equalTo: ratingView.leftAnchor).isActive = true
        noRatingLabel.isHidden = true
        
    }
    
    private class ImageCell: UICollectionViewCell {
        
        var image: Image? {
            didSet {
                if let image_url = image?.imageUrl {
                    imageView.sd_setImage(with: URL(string: image_url), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached)
                }
            }
        }
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            iv.clipsToBounds = true
            return iv
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .white
            contentView.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

extension ProductDetailTableViewCell1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detail?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.image = detail?.images?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = detail?.images?[indexPath.item].imageUrl
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: url!)!)
            DispatchQueue.main.async {
                let imageInfo = GSImageInfo(image: UIImage(data: data!)!, imageMode: .aspectFit)
                let transitionInfo = GSTransitionInfo(fromView: collectionView)
                let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                self.productDetailViewController?.presentImageViewer(view: imageViewer)
            }
        }
    }
    
}
