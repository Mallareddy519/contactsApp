//
//  ContactsHomeViewModel.swift
//  ContactsApp
//

import Foundation

protocol ViewModelBusinessLogic {
    func fetchContacts()
    func setSelectedContact(_ contact: ContactsHomeModel.Contact?)
}

class ContactsHomeViewModel: ContactsHomeDataStore {
    var contact: ContactsHomeModel.Contact?
    weak var view: ContactsHomeDisplayLogic?
    private let service: ContactsProvider
    
    init(service: ContactsProvider = NetworkAPI()) {
        self.service = service
    }
    
    func handleSuccessfetchContacts(_ response: ContactsResponse) {
        var counter = 0
        let result = response.data?.map({ user -> ContactsHomeModel.Contact in
            counter += 1
            return ContactsHomeModel.Contact(
                id: user.id ?? 0,
                avatar: user.avatar ?? "",
                firstName: user.first_name ?? "",
                lastName: user.last_name ?? "",
                mobile: "+6584118\(counter)75",
                email: user.email ?? "")
        }) ?? []
        view?.displayContacts(result)
    }
    
    func handleFailfetchContacts(_ error: APIError) {
        print("Occur API error.")
    }
}

extension ContactsHomeViewModel: ViewModelBusinessLogic {
    func fetchContacts() {
        service.fetchContacts { result in
            switch result {
            case.success(let response):
                self.handleSuccessfetchContacts(response)
            case.failure(let error):
                self.handleFailfetchContacts(error)
            }
        }
    }
    
    func setSelectedContact(_ contact: ContactsHomeModel.Contact?) {
        self.contact = contact
        view?.displayDetailContactView()
    }
}
