//
//  SearchField.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

class SearchField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.borderStyle = .none
        self.backgroundColor = .white
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.font = UIFont.systemFont(ofSize: 14)
        self.returnKeyType = .search
        self.autocorrectionType = .no
        self.tintColor = .clear
        
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 34))
        self.leftViewMode = .always
        self.leftView = spaceView
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
