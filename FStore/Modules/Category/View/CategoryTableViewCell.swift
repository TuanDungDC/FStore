//
//  CategoryTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class CategoryTableViewCell: HomeTableViewCell {
    
    var category: CategoryResponse? {
        didSet {
            if let name = category?.name {
                titleLabel.text = name
            }
            if let banner = category?.bannerUrl {
                bannerImageView.sd_setImage(with: URL(string: banner), placeholderImage: #imageLiteral(resourceName: "default-banner"), options: .refreshCached, context: nil)
            }
            collectionView.reloadData()
        }
    }
    
    private let cellId = "cellId"
    var categoryTableViewController: CategoryTableViewController?
    
    override func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 8).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 134).isActive = true
    }
    
    override func setupViews() {
        setupTitleLabel()
        setupBannerImageView()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.categories?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.childCategory = category?.categories?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height - 56, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let categoryName = category?.categories?[indexPath.item].name, let categoryId = category?.categories?[indexPath.item].id {
                categoryTableViewController?.showProductListController(categoryId: categoryId, categoryName: categoryName)
            }
    }
    
    
    private class CategoryCell: UICollectionViewCell {
        
        var childCategory: ChildCategoryResponse? {
            didSet {
                if let thumbnail = childCategory?.thumbnailUrl {
                    imageView.sd_setImage(with: URL(string: thumbnail), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached, context: nil)
                }
                if let name = childCategory?.name {
                    nameLabel.text = name
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
        
        let nameLabel: UILabel = {
            let l = UILabel()
            l.translatesAutoresizingMaskIntoConstraints = false
            l.font = UIFont.systemFont(ofSize: 14)
            l.textAlignment = .center
            l.numberOfLines = 3
            return l
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
            
            contentView.addSubview(nameLabel)
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
