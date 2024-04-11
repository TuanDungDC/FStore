//
//  UserResponse.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//

import UIKit

struct UserResponse: Decodable {

    var id: Int?
    var name: String?
    var phone: Int?
    var email: String?
    var gender: Int?
    var accountType: Int?
    var avatarUrl: String?
    var birthday: String?

    
}
