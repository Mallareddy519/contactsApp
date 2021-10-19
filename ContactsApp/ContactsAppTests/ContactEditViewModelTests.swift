//
//  ContactEditViewModelTests.swift
//  ContactsAppTests
//

import XCTest
@testable import ContactsApp

class ContactEditViewModelTests: XCTestCase {
    // MARK: Subject under test
    var sut: ContactEditViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = ContactEditViewModel(view: SpyContactEditDisplayLogic())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_createContactSuccess() {
        let spyView = SpyContactEditDisplayLogic()
        sut = ContactEditViewModel(createService: StubCreateContactAPI(.success), view: spyView)
        sut.entryPoint = .add
        sut.updateContact(firstName: "a", lastName: "s")
        wait(duration: 0.01)
        XCTAssert(spyView.updatedContactCalled)
    }
    
    func test_updateContactSuccess() {
        let spyView = SpyContactEditDisplayLogic()
        sut = ContactEditViewModel(updateService: StubUpdateContactAPI(.success), view: spyView)
        sut.entryPoint = .edit
        sut.updateContact(firstName: "q", lastName: "w")
        wait(duration: 0.01)
        XCTAssert(spyView.updatedContactCalled)
    }
    
    func test_createContactError() {
        let spyView = SpyContactEditDisplayLogic()
                sut = ContactEditViewModel(createService: StubCreateContactAPI(.internalError), view: spyView)
        sut.entryPoint = .add
        sut.updateContact(firstName: "a", lastName: "s")
        wait(duration: 0.01)
        XCTAssert(spyView.displayGenericErrorCalled)
    }
    
    func test_updateContactError() {
        let spyView = SpyContactEditDisplayLogic()
        sut = ContactEditViewModel(updateService: StubUpdateContactAPI(.internalError), view: spyView)
        sut.entryPoint = .edit
        sut.updateContact(firstName: "q", lastName: "w")
        wait(duration: 0.01)
        XCTAssert(spyView.displayGenericErrorCalled)
    }
    
    func test_getContact() {
        let spyView = SpyContactEditDisplayLogic()
        sut = ContactEditViewModel(view: spyView)
        sut.contact = ContactsHomeModel.Contact(id: 1, avatar: "", firstName: "", lastName: "", email: "")
        sut.getContact()
        XCTAssert(spyView.displayContactCalled)
    }
    
    func test_enableDoneButton() {
        let spyView = SpyContactEditDisplayLogic()
        sut = ContactEditViewModel(view: spyView)
        sut.enableDoneButton(ContactEditModel.UpdateData(firstname: "", lastname: "", mobile: "", email: ""))
        XCTAssert(spyView.enableDoneButtonCalled)
    }
}

extension ContactEditViewModelTests {
    class SpyContactEditDisplayLogic: ContactEditDisplayLogic {
        var displayContactCalled = false
        var updatedContactCalled = false
        var enableDoneButtonCalled = false
        var displayGenericErrorCalled = false
        
        func displayContact(contact: ContactsHomeModel.Contact) {
            displayContactCalled = true
        }
        
        func updatedContact() {
            updatedContactCalled = true
        }
        
        func enableDoneButton(enable: Bool) {
            enableDoneButtonCalled = true
        }
        
        func displayGenericError() {
            displayGenericErrorCalled = true
        }
    }
    
    class StubCreateContactAPI: NetworkAPI {
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
    
    class StubUpdateContactAPI: NetworkAPI {
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
                let object = UpdateResponse(data: UserInfo(id: 1, email: "", first_name: "", last_name: "", avatar: ""),
                                            support: Support(url: "", text: ""))
                completion(Result.success(object as! T))
            }
        }
    }
}
