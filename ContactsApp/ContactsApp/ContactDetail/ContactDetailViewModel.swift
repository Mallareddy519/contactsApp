//
//  ContactDetailViewModel.swift
//  ContactsApp
//

import Foundation

protocol DetailViewModelBusinessLogic {
    func fetchContact()
}

class ContactDetailViewModel: ContactDetailDataStore {
    var contact: ContactsHomeModel.Contact?
    private weak var view: ContactDetailDisplayLogic?
    
    init(view: ContactDetailDisplayLogic) {
        self.view = view
    }
    
}

extension ContactDetailViewModel: DetailViewModelBusinessLogic {
    func fetchContact() {
        guard let contact = contact else { return }
        view?.displayContact(contact)
    }
}
