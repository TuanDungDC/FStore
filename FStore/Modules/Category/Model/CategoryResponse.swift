//
//  CategoryResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct CategoryResponse: Decodable {
    var id: Int?
    var name: String?
    var bannerUrl: String?
    var categories: [ChildCategoryResponse]?
}

struct ChildCategoryResponse: Decodable {
    var id: Int?
    var name: String?
    var thumbnailUrl: String?
}
