//
//  ContactsHomeTableViewCell.swift
//  ContactsApp
//

import UIKit

class ContactsHomeTableViewCell: UITableViewCell {
    static let identifier = "\(ContactsHomeTableViewCell.self)"
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatar.layer.cornerRadius = 28
    }
    
    func configCell(model: ContactsHomeModel.Contact) {
        avatar.loadImageAsync(with: model.avatar)
        nameLabel.text = model.firstName + model.lastName
    }
}
