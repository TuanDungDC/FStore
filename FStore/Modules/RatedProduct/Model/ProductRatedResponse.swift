//
//  ProductRatedResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct RatedProductResponse: Decodable {
    var productId: Int?
    var rating: Int?
    var comment: String?
    var status: Int?
    var thumbnailUrl: String?
}
