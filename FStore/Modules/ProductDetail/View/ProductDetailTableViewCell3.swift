//
//  ProductDetailTableViewCell3.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//


import UIKit
import Cosmos

class ProductDetailTableViewCell3: ProductDetailTableViewCell2 {
    
    override var detail: ProductDetailResponse? {
        didSet {
            
            if let rating = detail?.rating {
                ratingView.isHidden = false
                ratingView.rating = Double(rating)
                totalRatingLabel.isHidden = false
                totalRatingLabel.text = "\(rating)/5"
                noRatingLabel.isHidden = true
            }

            else {
                noRatingLabel.isHidden = false
                noRatingLabel.text = "Chưa có đánh giá"
            }
            
            if let comment = detail?.comment {
                if comment > 0 {
                    totalCommentLabel.isHidden = false
                    totalCommentLabel.text = "(\(comment) đánh giá)"
                }
            }
        }
    }
    
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    
    let totalRatingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = MAIN_COLOR
        return l
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.sectionHeaderHeight = 0
        tbv.sectionFooterHeight = 0
        tbv.separatorStyle = .none
        return tbv
    }()
    
    override func setupViews() {
        
        contentView.autoresizingMask = .flexibleHeight
        
        contentView.addSubview(titleLabel)
        setupLayoutConstraintTitleLabel()
        
        contentView.addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        ratingView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ratingView.isHidden = true
        
        contentView.addSubview(totalRatingLabel)
        totalRatingLabel.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 8).isActive = true
        totalRatingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        totalRatingLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        totalRatingLabel.isHidden = true
        
        contentView.addSubview(totalCommentLabel)
        totalCommentLabel.font = UIFont.systemFont(ofSize: 14)
        totalCommentLabel.leftAnchor.constraint(equalTo: totalRatingLabel.rightAnchor
            , constant: 8).isActive = true
        totalCommentLabel.centerYAnchor.constraint(equalTo: totalRatingLabel.centerYAnchor).isActive = true
        totalCommentLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        totalRatingLabel.isHidden = true
        
        contentView.addSubview(noRatingLabel)
        noRatingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        noRatingLabel.leftAnchor.constraint(equalTo: ratingView.leftAnchor).isActive = true
        noRatingLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        noRatingLabel.isHidden = true
        
        contentView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: cellId2)
        
    }
    
    private class ButtonTableViewCell: UITableViewCell {
        
        var productDetailViewController: ProductDetailViewController?
        var comments: [CommentResponse]?
        
        lazy var viewAllCommentsButton: UIButton = {
            let b = UIButton()
            b.translatesAutoresizingMaskIntoConstraints = false
            b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            b.setTitleColor(MAIN_COLOR, for: .normal)
            b.addTarget(self, action: #selector(handlePresentRatingAndCommentController), for: .touchUpInside)
            return b
        }()
        
        @objc func handlePresentRatingAndCommentController() {
            productDetailViewController?.presentAllReviewTableViewController(comments: comments ?? [])
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .white
            contentView.addSubview(viewAllCommentsButton)
            viewAllCommentsButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            viewAllCommentsButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            viewAllCommentsButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            viewAllCommentsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}


extension ProductDetailTableViewCell3: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let commentsCount = detail?.comments?.count {
            if commentsCount > 3 {
                return 2
            }
            else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = detail?.comments?.count {
                if count > 3 {
                    return 3
                }
                else {
                    return count
                }
            }
            return 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentTableViewCell
            cell.comment = detail?.comments?[indexPath.item]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! ButtonTableViewCell
            if let totalComments = detail?.comments?.count {
                cell.viewAllCommentsButton.setTitle("Xem Tất Cả (\(totalComments))", for: .normal)
                cell.comments = detail?.comments
                cell.productDetailViewController = productDetailViewController
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableView.layoutIfNeeded()
        self.layoutIfNeeded()
        let contentSize = tableView.contentSize
        return CGSize(width: contentSize.width, height: contentSize.height + 69.5)
    }
    
}
