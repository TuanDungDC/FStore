//
//  HomeTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var homeResponse: HomeResponse? {
        didSet {
            
            collectionView.reloadData()
            
            if let title = homeResponse?.title {
                titleLabel.text = title
            }
            if let banner = homeResponse?.banner {
                bannerImageView.sd_setImage(with: URL(string: banner), placeholderImage: #imageLiteral(resourceName: "default-banner"), options: .refreshCached, context: nil)
            }
        }
    }
    
    private let cellId = "cellId"
    var homeTableViewController: HomeTableViewController?
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    lazy var seeMoreButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("XEM THÊM", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.setTitleColor(MAIN_COLOR, for: .normal)
        b.addTarget(self, action: #selector(handleSeeMore), for: .touchUpInside)
        b.sizeToFit()
        return b
    }()
    
    let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        //iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSeeMore() {
        homeTableViewController?.showProductListController(categoryId: homeResponse!.id!, categoryName: homeResponse!.title!)
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    func setupSeeMoreButton() {
        contentView.addSubview(seeMoreButton)
        seeMoreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        seeMoreButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        seeMoreButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    func setupBannerImageView() {
        contentView.addSubview(bannerImageView)
        bannerImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        bannerImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        bannerImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        bannerImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 290).isActive = true
    }
    
    func setupViews() {
        backgroundColor = .white
        setupTitleLabel()
        setupSeeMoreButton()
        setupBannerImageView()
        setupCollectionView()
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeResponse?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCollectionViewCell
        cell.productResponse = homeResponse?.products?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productId = homeResponse?.products?[indexPath.item].id {
            homeTableViewController?.showDetailViewController(productId: productId)
        }
    }
    
}
