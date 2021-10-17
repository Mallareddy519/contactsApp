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
}

struct UpdateResponse: Codable {
    let data: UserInfo?
    let support: Support?
}
