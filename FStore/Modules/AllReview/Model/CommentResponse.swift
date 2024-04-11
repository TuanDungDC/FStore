//
//  CommentResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct CommentResponse: Decodable {
    var rating: Int?
    var commentText: String?
    var userName: String?
    var createAt: String?
}

