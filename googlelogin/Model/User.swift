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

class User: NSObject, NSCoding {
    
    var name, email, avatar, age: String?
    
    init(name: String = "", avatar: String = "", email: String = "", age: String = "") {
        self.name = name
        self.email = email
        self.avatar = avatar
        self.age = age
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        self.age = aDecoder.decodeObject(forKey: "age") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(age, forKey: "age")
    }
}
