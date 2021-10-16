//
//  ContactsHomeModel.swift
//  ContactsApp
//

import UIKit

enum ContactsHomeModel {
    struct Contact {
        let id: Int
        let avatar: String
        let firstName, lastName: String
        let mobile, email: String
    }
}

struct ContactsResponse: Codable {
    let page, per_page, total, total_pages: Int?
    let data: [UserInfo]?
    let support: Support?
}

struct UserInfo: Codable {
    let id: Int?
    let email, first_name, last_name: String?
    let avatar: String?
}

struct Support: Codable {
    let url: String?
    let text: String?
}
