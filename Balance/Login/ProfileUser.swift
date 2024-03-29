//
//  User.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/04/2023.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation
import SwiftUI

struct ProfileUser: Codable, Equatable, Hashable, Identifiable {
    let id: String
    let displayName: String
    let email: String
    let parentEmail: String
    let birthday: String
    let country: String
    let phone: String
    var avatar: String
    var accesory: String
    let password: String

    init() {
        self.id = ""
        self.displayName = ""
        self.email = ""
        self.parentEmail = ""
        self.birthday = ""
        self.country = ""
        self.phone = ""
        self.avatar = ""
        self.accesory = ""
        self.password = ""
    }
    
    init(
        id: String,
        displayName: String,
        email: String,
        parentEmail: String,
        birthday: String,
        country: String,
        phone: String,
        avatar: String,
        accesory: String,
        password: String
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.parentEmail = parentEmail
        self.birthday = birthday
        self.country = country
        self.phone = phone
        self.avatar = avatar
        self.accesory = accesory
        self.password = password
    }
    
    func description() -> String {
        let description = id + "-" +
        displayName + "-" +
        email + "-" +
        parentEmail + "-" +
        birthday + "-" +
        country + "-" +
        phone + "-" +
        avatar + "-" +
        accesory
        return description
    }
}
