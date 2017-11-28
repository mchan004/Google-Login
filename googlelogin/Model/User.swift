//
//  User.swift
//  googlelogin
//
//  Created by Administrator on 11/28/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation

//class Save {
//    static var user: User?
//}

struct User {
    var name, email, avatar, age: String?
    
    init(name: String = "", avatar: String = "", email: String = "", age: String = "") {
        self.name = name
        self.email = email
        self.avatar = avatar
        self.age = age
    }
}
