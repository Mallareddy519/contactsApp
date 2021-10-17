//
//  ContactDetailRouter.swift
//  ContactsApp
//

import UIKit

protocol ContactDetailDataStore {
    var contact: ContactsHomeModel.Contact? { get set }
}

@objc protocol ContactDetailRoutingLogic {
    func routeToEditContactView()
}

protocol ContactDetailDataPassing {
    var dataStore: ContactDetailDataStore? { get }
}

class ContactDetailRouter: NSObject, ContactDetailRoutingLogic, ContactDetailDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ContactDetailDataStore?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToEditContactView() {
        let destinationVC = ContactEditViewController.initFromStoryboard()
        guard var destinationDS = destinationVC.router?.dataStore, let dataStore = self.dataStore else { return }
        passDataToContactEditView(source: dataStore, destination: &destinationDS)
        viewController?.show(destinationVC, sender: nil)
    }
    
    func passDataToContactEditView(source: ContactDetailDataStore,
                                   destination: inout ContactEditDataStore) {
        destination.contact = source.contact
        destination.entryPoint = .edit
    }
}
