//
//  ContactDetailViewModelTests.swift
//  ContactsAppTests
//

import XCTest
@testable import ContactsApp

class ContactDetailViewModelTests: XCTestCase {
    // MARK: Subject under test
    var sut: ContactDetailViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = ContactDetailViewModel(view: SpyContactDetailDisplayLogic())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_fetchContact() {
        let spyView = SpyContactDetailDisplayLogic()
        sut = ContactDetailViewModel(view: spyView)
        sut.contact = ContactsHomeModel.Contact(id: 1, avatar: "", firstName: "", lastName: "", email: "")
        sut.fetchContact()
        XCTAssert(spyView.displayContactCalled)
    }
}

extension ContactDetailViewModelTests {
    class SpyContactDetailDisplayLogic: ContactDetailDisplayLogic {
        var displayContactCalled = false
        
        func displayContact(_ contact: ContactsHomeModel.Contact) {
            displayContactCalled = true
        }
    }
}
