//
//  ContactsHomeViewController.swift
//  ContactsApp
//

import UIKit

protocol ContactsHomeDisplayLogic: class {
    func displayContacts(_ contacts: [[ContactsHomeModel.Contact]])
    func displayDetailContactView()
    func displayGenericError()
}

class ContactsHomeViewController: UIViewController {
    var viewModel: ViewModelBusinessLogic?
    var router: (ContactsHomeRoutingLogic & ContactsHomeDataPassing)?
    var contacts: [[ContactsHomeModel.Contact]] = []
    
    @IBOutlet weak private var tableView: UITableView!
    private let spinner = UIActivityIndicatorView(style: .large)
    private var isShowGroups = false
    var alphabetOrder = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
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
        let viewModel = ContactsHomeViewModel(view: viewController)
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
        isShowGroups.toggle()
        navigationItem.leftBarButtonItem?.tintColor = isShowGroups ? .green : .systemBlue
        viewModel?.getGroupedContacts(isShowGroups)
    }
    
    @objc func tapAddButton() {
        router?.routeToAddContactView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(
            UINib(nibName: ContactsHomeTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ContactsHomeTableViewCell.identifier)
        tableView.selectionFollowsFocus = true
        spinner.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        spinner.color = UIColor.green
        spinner.hidesWhenStopped = true
        tableView.tableFooterView = spinner
    }
    
    func fetchContacts() {
        viewModel?.fetchContacts(isShowGroups)
    }
}

extension ContactsHomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Side List in tableview
    public func numberOfSections(in tableView: UITableView) -> Int {
        return isShowGroups ? alphabetOrder.count : (contacts.count > 0 ? 1 : 0)
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isShowGroups ? self.alphabetOrder : nil //Side Section title
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isShowGroups ? alphabetOrder[section] : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsHomeTableViewCell.identifier, for: indexPath) as? ContactsHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(model: contacts[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelectedContact(contacts[indexPath.section][indexPath.row])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reloadDistance = CGFloat(30.0)
        if y > h + reloadDistance {
            spinner.startAnimating()
            fetchContacts()
        }
    }
}

extension ContactsHomeViewController: ContactsHomeDisplayLogic {
    func displayContacts(_ contacts: [[ContactsHomeModel.Contact]]) {
        self.contacts = contacts
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func displayDetailContactView() {
        router?.routeToDetailContactView()
    }
    
    func displayGenericError() {
        print("Occur API error.")
    }
}
