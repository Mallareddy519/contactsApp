//
//  ContactsHomeViewModel.swift
//  ContactsApp
//

import Foundation

protocol ViewModelBusinessLogic {
    func fetchContacts(_ isShowGroups: Bool)
    func setSelectedContact(_ contact: ContactsHomeModel.Contact?)
    func getGroupedContacts(_ isShowGroups: Bool)
}

class ContactsHomeViewModel: ContactsHomeDataStore {
    var contact: ContactsHomeModel.Contact?
    private weak var view: ContactsHomeDisplayLogic?
    
    private let service: ContactsFetchProvider
    private var contacts: [ContactsHomeModel.Contact] = []
    var alphabetOrder: [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
    init(service: ContactsFetchProvider = NetworkAPI(),
         view: ContactsHomeDisplayLogic) {
        self.service = service
        self.view = view
    }
    
    func handleSuccessfetchContacts(_ response: ContactsResponse, isShowGroups: Bool) {
        let respContacts = response.data?.map({ user -> ContactsHomeModel.Contact in
            return ContactsHomeModel.Contact(
                id: user.id ?? 0,
                avatar: user.avatar ?? "",
                firstName: user.first_name ?? "",
                lastName: user.last_name ?? "",
                email: user.email ?? "")
        }) ?? []
        contacts.append(contentsOf: respContacts)
        let groupsContact = makeGroupContacts(contacts: contacts, isShowGroups: isShowGroups)
        view?.displayContacts(groupsContact)
    }
    
    private func makeGroupContacts(contacts: [ContactsHomeModel.Contact],
                                   isShowGroups: Bool) -> [[ContactsHomeModel.Contact]] {
        let groupContacts = alphabetOrder.map { order -> [ContactsHomeModel.Contact] in
            let orderList = contacts.filter({ $0.firstName.uppercased().first == order }).sorted(by: { $0.firstName < $1.firstName })
            return orderList
        }
        return isShowGroups ? groupContacts : [groupContacts.reduce([], +)]
    }
    
    func handleFailfetchContacts(_ error: APIError) {
        print("Occur API error.")
    }
}

extension ContactsHomeViewModel: ViewModelBusinessLogic {
    func fetchContacts(_ isShowGroups: Bool) {
        service.fetchContacts { result in
            switch result {
            case.success(let response):
                self.handleSuccessfetchContacts(response, isShowGroups: isShowGroups)
            case.failure(let error):
                self.handleFailfetchContacts(error)
            }
        }
    }
    
    func setSelectedContact(_ contact: ContactsHomeModel.Contact?) {
        self.contact = contact
        view?.displayDetailContactView()
    }
    
    func getGroupedContacts(_ isShowGroups: Bool) {
        let groupsContact = makeGroupContacts(contacts: contacts, isShowGroups: isShowGroups)
        view?.displayContacts(groupsContact)
    }
}
