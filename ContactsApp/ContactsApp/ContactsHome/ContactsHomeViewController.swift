//
//  ContactsHomeViewController.swift
//  ContactsApp
//

import UIKit

protocol ContactsHomeDisplayLogic: class {
    func displayContacts(_ contacts: [ContactsHomeModel.Contact])
    func displayDetailContactView()
}

class ContactsHomeViewController: UIViewController {
    var viewModel: ViewModelBusinessLogic?
    var router: (ContactsHomeRoutingLogic & ContactsHomeDataPassing)?
    var contacts: [ContactsHomeModel.Contact] = []
    
    @IBOutlet weak private var tableView: UITableView!
    
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
        let viewModel = ContactsHomeViewModel()
        viewModel.view = viewController
        let router = ContactsHomeRouter(viewController)
        router.dataStore = viewModel
        
        viewController.viewModel = viewModel
        viewController.router = router
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavbar()
        setupTableView()
        fetchContacts()
    }
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(tapAddButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Groups",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapGroupsButton))
    }
    
    @objc func tapGroupsButton() {
        print("tap Groups Button.")
    }
    
    @objc func tapAddButton() {
        print("tap Add Button.")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(
            UINib(nibName: ContactsHomeTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ContactsHomeTableViewCell.identifier)
    }
    
    func fetchContacts() {
        viewModel?.fetchContacts()
    }
}

extension ContactsHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsHomeTableViewCell.identifier, for: indexPath) as? ContactsHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(model: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelectedContact(contacts[indexPath.row])
    }
}

extension ContactsHomeViewController: ContactsHomeDisplayLogic {
    func displayContacts(_ contacts: [ContactsHomeModel.Contact]) {
        self.contacts = contacts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayDetailContactView() {
        router?.routeToDetailContactView()
    }
}
