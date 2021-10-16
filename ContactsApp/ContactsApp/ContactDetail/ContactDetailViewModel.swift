//
//  ContactDetailViewModel.swift
//  ContactsApp
//

import Foundation

protocol DetailViewModelBusinessLogic {
    func fetchContact()
}

class ContactDetailViewModel: ContactsDetailDataStore {
    var contact: ContactsHomeModel.Contact?
    weak var view: ContactsDetailDisplayLogic?
    
}

extension ContactDetailViewModel: DetailViewModelBusinessLogic {
    func fetchContact() {
        guard let contact = contact else { return }
        view?.displayContact(contact)
    }
}
