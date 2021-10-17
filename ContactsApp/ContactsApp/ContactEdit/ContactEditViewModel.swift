//
//  ContactEditViewModel.swift
//  ContactsApp
//

import Foundation


protocol EditViewModelBusinessLogic {
    func getContact()
    func updateContact(firstName: String, lastName: String)
    func enableDoneButton(_ request: ContactEditModel.UpdateData)
}

class ContactEditViewModel: ContactEditDataStore {
    var entryPoint: ContactEditModel.EntryPoint = .add
    var contact: ContactsHomeModel.Contact?
    private weak var view: ContactEditDisplayLogic?
    
    private let updateService: ContactUpdateProvider
    private let createService: ContactCreateProvider
    
    init(updateService: ContactUpdateProvider = NetworkAPI(),
         createService: ContactCreateProvider = NetworkAPI(),
         view: ContactEditDisplayLogic) {
        self.updateService = updateService
        self.createService = createService
        self.view = view
    }
    
    private func callServiceUpdateContact(firstName: String, lastName: String) {
        updateService.updateContact(userId: String(contact?.id ?? 0),
                                    name: firstName,
                                    job: lastName) { [weak self] result in
            switch result {
            case.success(let response):
                self?.handleUpdateSuccess(response)
            case.failure(let error):
                self?.handleFailfetchContacts(error)
            }
        }
    }
    
    private func handleUpdateSuccess(_ response: UpdateResponse) {
        print("Update contact success.")
        view?.updatedContact()
    }
    
    private func callServiceCreateContact(firstName: String, lastName: String) {
        createService.createContact(name: firstName, job: lastName) { [weak self] result in
            switch result {
            case.success(let response):
                self?.handleCreateSuccess(response)
            case.failure(let error):
                self?.handleFailfetchContacts(error)
            }
        }
    }
    
    private func handleCreateSuccess(_ response: ContactsResponse) {
        print("Create contact success.")
        view?.updatedContact()
    }
    
    func handleFailfetchContacts(_ error: APIError) {
        print("Occur API error.")
    }
}

extension ContactEditViewModel: EditViewModelBusinessLogic {
    func getContact() {
        guard let contact = contact else { return }
        view?.displayContact(contact: contact)
    }
    
    func updateContact(firstName: String, lastName: String) {
        switch entryPoint {
        case .add:
            callServiceCreateContact(firstName: firstName, lastName: lastName)
        case .edit:
            callServiceUpdateContact(firstName: firstName, lastName: lastName)
        }
    }
    
    func enableDoneButton(_ request: ContactEditModel.UpdateData) {
        var isEnable = false
        switch entryPoint {
        case .add:
            let result = [request.firstname,
                          request.lastname,
                          request.mobile,
                          request.email].map { text -> Bool in
                if let text = text, !text.isEmpty { return true }
                else { return false  }
            }.contains(false)
            isEnable = !result
        case .edit:
            isEnable = request.firstname != contact?.firstName || request.lastname != contact?.lastName
        }
        view?.enableDoneButton(enable: isEnable)
    }
}
