//
//  ContactEditViewController.swift
//  ContactsApp
//

import UIKit

protocol ContactEditDisplayLogic: class {
    func displayContact(contact: ContactsHomeModel.Contact)
    func updatedContact()
    func enableDoneButton(enable: Bool)
}

class ContactEditViewController: UIViewController {
    var viewModel: EditViewModelBusinessLogic?
    var router: (ContactEditRoutingLogic & ContactEditDataPassing)?
    
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var firstNameTitle: UILabel!
    @IBOutlet private weak var firstNameTF: UITextField!
    @IBOutlet private weak var lastNameTitle: UILabel!
    @IBOutlet private weak var lastNameTF: UITextField!
    @IBOutlet private weak var mobileTitle: UILabel!
    @IBOutlet private weak var mobileTF: UITextField!
    @IBOutlet private weak var emailNameTitle: UILabel!
    @IBOutlet private weak var emailTF: UITextField!
    
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
        let viewModel = ContactEditViewModel(view: viewController)
        let router = ContactEditRouter(viewController)
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
        setupTextFields()
        firstNameTitle.text = "First Name"
        lastNameTitle.text = "Last Name"
        mobileTitle.text = "Mobile"
        emailNameTitle.text = "Email"
        updateViews()
        viewModel?.getContact()
    }
    
    static func initFromStoryboard() -> ContactEditViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: "ContactEditViewController") as? ContactEditViewController
        return destinationVC ?? ContactEditViewController()
    }
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(tapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapCancelButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func tapDoneButton() {
        updateContact()
    }
    
    @objc func tapCancelButton() {
        router?.routeToBack()
    }
    
    private func setupTextFields() {
        for textField in [firstNameTF, lastNameTF, mobileTF, emailTF] {
            textField?.delegate = self
        }
    }
    
    private func updateViews() {
        switch router?.dataStore?.entryPoint {
        case .edit:
            mobileTF.isUserInteractionEnabled = false
            emailTF.isUserInteractionEnabled = false
        default: break
        }
    }
    
    private func updateContact() {
        viewModel?.updateContact(firstName: firstNameTF.text ?? "", lastName: lastNameTF.text ?? "")
    }
}

extension ContactEditViewController: ContactEditDisplayLogic {
    func displayContact(contact: ContactsHomeModel.Contact) {
        avatar?.loadImageAsync(with: contact.avatar)
        firstNameTF.text = contact.firstName
        lastNameTF.text = contact.lastName
        mobileTF.text = String(contact.id)
        emailTF.text = contact.email
    }
    
    func updatedContact() {
        router?.returnToHome()
    }
    
    func enableDoneButton(enable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }
}

extension ContactEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let request = ContactEditModel.UpdateData(firstname: firstNameTF.text,
                                                  lastname: lastNameTF.text,
                                                  mobile: mobileTF.text,
                                                  email: emailTF.text)
        viewModel?.enableDoneButton(request)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
