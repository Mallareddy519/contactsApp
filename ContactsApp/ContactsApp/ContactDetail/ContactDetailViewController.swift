//
//  ContactDetailViewController.swift
//  ContactsApp
//

import UIKit

protocol ContactDetailDisplayLogic: class {
    func displayContact(_ contact: ContactsHomeModel.Contact)
}

class ContactDetailViewController: UIViewController {
    var viewModel: DetailViewModelBusinessLogic?
    var router: (ContactDetailRoutingLogic & ContactDetailDataPassing)?
    
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageTitle: UILabel!
    @IBOutlet private weak var callTitle: UILabel!
    @IBOutlet private weak var emailTitle: UILabel!
    @IBOutlet private weak var favoriteTitle: UILabel!
    @IBOutlet private weak var mobileNameLabel: UILabel!
    @IBOutlet private weak var mobileLabel: UILabel!
    @IBOutlet private weak var emailNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var bottomContainerView: UIView!
  
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
        let viewModel = ContactDetailViewModel(view: viewController)
        let router = ContactDetailRouter(viewController)
        router.dataStore = viewModel
        
        viewController.viewModel = viewModel
        viewController.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavbar()
        topContainerView.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        avatar?.layer.cornerRadius = 72
        fetchContacts()
    }
    
    static func initFromStoryboard() -> ContactDetailViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController
        return destinationVC ?? ContactDetailViewController()
    }
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(tapEditButton))
    }
    
    @objc func tapEditButton() {
        router?.routeToEditContactView()
    }
    
    private func fetchContacts() {
        viewModel?.fetchContact()
    }
    
    @IBAction func tapMessageButton(_ sender: Any) {
        print("tap Message Button.")
    }
    
    @IBAction func tapCallButton(_ sender: Any) {
        print("tap Call Button.")
    }
    
    @IBAction func tapEmailButton(_ sender: Any) {
        print("tap Email Button.")
    }
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        print("tap Favorite Button.")
    }
}

extension ContactDetailViewController: ContactDetailDisplayLogic {
    func displayContact(_ contact: ContactsHomeModel.Contact) {
        avatar?.loadImageAsync(with: contact.avatar)
        nameLabel?.text = contact.firstName + " " + contact.lastName
        messageTitle?.text = "message"
        callTitle?.text = "call"
        emailTitle?.text = "email"
        favoriteTitle?.text = "favorite"
        emailNameLabel?.text = "email"
        mobileNameLabel?.text = "mobile"
        emailLabel?.text = contact.email
        mobileLabel?.text = String(contact.id)
    }
}
