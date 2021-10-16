//
//  ContactDetailRouter.swift
//  ContactsApp
//

import UIKit

protocol ContactsDetailDataStore {
    var contact: ContactsHomeModel.Contact? { get set }
}

@objc protocol ContactsDetailRoutingLogic {
    func routeToEditContactView()
}

protocol ContactsDetailDataPassing {
    var dataStore: ContactsDetailDataStore? { get }
}

class ContactDetailRouter: NSObject, ContactsDetailRoutingLogic, ContactsDetailDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ContactsDetailDataStore?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToEditContactView() {
        let destinationVC = ContactDetailViewController.initFromStoryboard()
        viewController?.show(destinationVC, sender: nil)
    }
}
