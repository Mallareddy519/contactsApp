//
//  ContactEditRouter.swift
//  ContactsApp
//

import UIKit

protocol ContactEditDataStore {
    var contact: ContactsHomeModel.Contact? { get set }
    var entryPoint: ContactEditModel.EntryPoint { get set }
}

@objc protocol ContactEditRoutingLogic {
    func routeToBack()
    func returnToHome()
}

protocol ContactEditDataPassing {
    var dataStore: ContactEditDataStore? { get }
}

class ContactEditRouter: NSObject, ContactEditRoutingLogic, ContactEditDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ContactEditDataStore?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToBack() {
        DispatchQueue.main.async {
            self.viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func returnToHome() {
        DispatchQueue.main.async {
            self.viewController?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

