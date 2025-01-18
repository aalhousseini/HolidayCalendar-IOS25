//
//  LocalData.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
//

import Foundation
import SwiftData

@Model
 class User {
    @Attribute(.unique)
    var userId: String
    var username: String
    var password: String
    var email: String
    //var createdAt: Date = Date()
     var name: String
  
   
     init(userId: String, username: String, password: String, email: String, name: String) {
         self.userId = userId
         self.username = username
         self.password = password
         self.email = email
         self.name = name
     }
}
