//
//  HeaderHomeTableViewCell.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit
import FSPagerView

class HeaderHomeTableViewCell: UITableViewCell {
    
    var homeResponse: HomeResponse? {
        didSet {
            pagerView.reloadData()
            if let count = homeResponse?.products?.count {
                pageControl.numberOfPages = count
                if count <= 1 {
                    pageControl.isHidden = true
                }
                else {
                    pageControl.isHidden = false
                }
            }
        }
    }
    
    private let cellId = "cellId"
    
    lazy var pagerView: FSPagerView = {
        let pv = FSPagerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.delegate = self
        pv.dataSource = self
        pv.isInfinite = true
        pv.automaticSlidingInterval = 3
        return pv
    }()
    
    let pageControl: FSPageControl = {
        let pc = FSPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.setStrokeColor(.lightGray, for: .normal)
        pc.setStrokeColor(MAIN_COLOR, for: .selected)
        pc.setFillColor(MAIN_COLOR, for: .selected)
        pc.setFillColor(.lightGray, for: .normal)
        pc.currentPage = 0
        return pc
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(pagerView)
        pagerView.register(PagerViewCell.self, forCellWithReuseIdentifier: cellId)
        pagerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pagerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        pagerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        pagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        pageControl.leftAnchor.constraint(equalTo: pagerView.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: pagerView.rightAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private class PagerViewCell: FSPagerViewCell {
        
        var banner: ProductResponse? {
            didSet {
                if let thumbnailUrl = banner?.thumbnailUrl {
                    bannerImageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: #imageLiteral(resourceName: "default-product"), options: .refreshCached, context: nil)
                }
            }
        }
        
        let bannerImageView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            //iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 5
            return iv
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.layer.shadowRadius = 0
            contentView.addSubview(bannerImageView)
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
            bannerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
            bannerImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

extension HeaderHomeTableViewCell: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeResponse?.products?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellId, at: index) as! PagerViewCell
        cell.banner = homeResponse?.products?[index]
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
}
