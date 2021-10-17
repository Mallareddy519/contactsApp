//
//  ContactEditModel.swift
//  ContactsApp
//

import Foundation

enum ContactEditModel {
    
    enum EntryPoint {
        case add
        case edit
    }
    
    struct UpdateData {
        var firstname: String?
        var lastname: String?
        var mobile: String?
        var email: String?
    }
}

struct UpdateResponse: Codable {
    let data: UserInfo?
    let support: Support?
}
