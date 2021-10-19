//
//  ContactsHomeViewModelTests.swift
//  ContactsAppTests
//

import XCTest
@testable import ContactsApp

class ContactsHomeViewModelTests: XCTestCase {
    // MARK: Subject under test
    var sut: ContactsHomeViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = ContactsHomeViewModel(view: SpyContactsHomeDisplayLogic())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_fetchContactsSuccess() {
        let spyView = SpyContactsHomeDisplayLogic()
        sut = ContactsHomeViewModel(service: StubNetworkAPI(.success), view: spyView)
        sut.fetchContacts(false)
        wait(duration: 0.1)
        XCTAssert(spyView.displayContactsCalled)
    }
    
    func test_fetchContactsSuccessWithGrouped() {
        let spyView = SpyContactsHomeDisplayLogic()
        sut = ContactsHomeViewModel(service: StubNetworkAPI(.success), view: spyView)
        sut.fetchContacts(false)
        wait(duration: 0.1)
        sut.getGroupedContacts(true)
        XCTAssert(spyView.displayContactsCalled)
    }
    
    func test_setSelectedContact() {
        let spyView = SpyContactsHomeDisplayLogic()
        sut = ContactsHomeViewModel(view: spyView)
        sut.setSelectedContact(ContactsHomeModel.Contact(id: 1, avatar: "", firstName: "", lastName: "", email: ""))
        XCTAssert(spyView.displayDetailContactViewCalled)
    }
    
    func test_fetchContactsError() {
        let spyView = SpyContactsHomeDisplayLogic()
        sut = ContactsHomeViewModel(service: StubNetworkAPI(.internalError), view: spyView)
        sut.fetchContacts(false)
        wait(duration: 0.1)
        XCTAssert(spyView.displayGenericErrorCalled)
    }
}

extension ContactsHomeViewModelTests {
    class SpyContactsHomeDisplayLogic: ContactsHomeDisplayLogic {
        var displayContactsCalled = false
        var displayDetailContactViewCalled = false
        var displayGenericErrorCalled = false
        
        func displayContacts(_ contacts: [[ContactsHomeModel.Contact]]) {
            displayContactsCalled = true
        }
        
        func displayDetailContactView() {
            displayDetailContactViewCalled = true
        }
        
        func displayGenericError() {
            displayGenericErrorCalled = true
        }
    }
    
    class StubNetworkAPI: NetworkAPI {
        enum Results {
            case success
            case internalError
            case serverError
            case parsingError
        }
        private let result: Results
        
        init(_ result: Results) {
            self.result = result
        }
        
        override func request<T>(endpoint: Endpoint,
                                 method: Method,
                                 params: [String: Any],
                                 completion: @escaping((Result<T, APIError>) -> Void)) where T : Decodable, T : Encodable {
            switch result {
            case .internalError:
                completion(.failure(.internalError))
            default:
                call(with: URLRequest(url: URL(string: "123")!), completion: completion)
            }
        }
        
        override func call<T>(with request: URLRequest,
                              completion: @escaping ((Result<T, APIError>) -> Void)) where T : Decodable, T : Encodable {
            switch result {
            case .serverError:
                completion(.failure(.serverError))
            case .parsingError:
                completion(.failure(.parsingError))
            default:
                let object = ContactsResponse(page: 1, per_page: 1, total: 1, total_pages: 1,
                                              data: [UserInfo(id: 1, email: "abc@gmail.com",
                                                              first_name: "first name", last_name: "last name",
                                                              avatar: "avatar")],
                                              support: Support(url: "", text: ""))
                completion(Result.success(object as! T))
            }
        }
    }
}

extension XCTestCase {
    /**
     Description:
     wait for task to finish
     - Parameters:
     - duration: wait duration
     - description: This string will be displayed in the test log to help diagnose failures.
     */
    open func wait(duration: TimeInterval, description: String = "") {
        
        let waitExpection = expectation(description: description)
        
        let deadline = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            waitExpection.fulfill()
        }
        
        waitForExpectations(timeout: duration + 0.5, handler: nil)
    }
}
