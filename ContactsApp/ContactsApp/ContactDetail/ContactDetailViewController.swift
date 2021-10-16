//
//  ContactDetailViewController.swift
//  ContactsApp
//

import UIKit

protocol ContactsDetailDisplayLogic: class {
    func displayContact(_ contacts: ContactsHomeModel.Contact)
}

class ContactDetailViewController: UIViewController {
    var viewModel: DetailViewModelBusinessLogic?
    var router: (ContactsDetailRoutingLogic & ContactsDetailDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let viewModel = ContactDetailViewModel()
        viewController.viewModel = viewModel
        viewModel.view = viewController
        let router = ContactDetailRouter(viewController)
        viewController.router = router
        router.dataStore = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavbar()
        fetchContacts()
    }
    
    static func initFromStoryboard() -> ContactDetailViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ContactDetailViewController ?? ContactDetailViewController()
    }
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(tapEditButton))
    }
    
    @objc func tapEditButton() {
        print("tap Edit Button.")
    }
    
    private func fetchContacts() {
        viewModel?.fetchContact()
    }
}

extension ContactDetailViewController: ContactsDetailDisplayLogic {
    func displayContact(_ contacts: ContactsHomeModel.Contact) {
        print("displaying Contact")
    }
}
