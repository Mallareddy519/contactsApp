//
//  ContactsHomeRouter.swift
//  ContactsApp
//

import UIKit

protocol ContactsHomeDataStore {
    var contact: ContactsHomeModel.Contact? { get set }
}

@objc protocol ContactsHomeRoutingLogic {
    func routeToAddContactView()
    func routeToDetailContactView()
}

protocol ContactsHomeDataPassing {
    var dataStore: ContactsHomeDataStore? { get }
}

class ContactsHomeRouter: NSObject, ContactsHomeRoutingLogic, ContactsHomeDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ContactsHomeDataStore?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToAddContactView() {
        let destinationVC = ContactEditViewController.initFromStoryboard()
        guard var destinationDS = destinationVC.router?.dataStore, let dataStore = self.dataStore else { return }
        passDataToContactAddView(source: dataStore, destination: &destinationDS)
        viewController?.show(destinationVC, sender: nil)
    }
    
    func passDataToContactAddView(source: ContactsHomeDataStore,
                                  destination: inout ContactEditDataStore) {
        destination.entryPoint = .add
    }
    
    func routeToDetailContactView() {
        let destinationVC = ContactDetailViewController.initFromStoryboard()
        guard var destinationDS = destinationVC.router?.dataStore, let dataStore = self.dataStore else { return }
        passDataToContactDetailView(source: dataStore, destination: &destinationDS)
        viewController?.show(destinationVC, sender: nil)
    }
    
    func passDataToContactDetailView(source: ContactsHomeDataStore,
                                     destination: inout ContactDetailDataStore) {
        destination.contact = source.contact
    }
}
