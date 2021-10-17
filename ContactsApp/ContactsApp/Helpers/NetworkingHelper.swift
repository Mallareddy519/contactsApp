
import Foundation

public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol ContactsFetchProvider {
    func fetchContacts(completion: @escaping((Result<ContactsResponse, APIError>) -> Void))
}

protocol ContactCreateProvider {
    func createContact(name: String,
                       job: String,
                       completion: @escaping ((Result<ContactsResponse, APIError>) -> Void))
}

protocol ContactUpdateProvider {
    func updateContact(userId: String,
                       name: String,
                       job: String,
                       completion: @escaping ((Result<UpdateResponse, APIError>) -> Void))
}

public class NetworkAPI {
    private let baseURL = "https://reqres.in/api/users"
    
    enum Endpoint {
        case perPage(endPoint: String)
        case update(endPoint: String)
        case empty
        
        static func getEndPoint(_ type: Endpoint) -> String {
            switch type {
            case .perPage(let endPoint):
                return "?per_page=\(endPoint)"
            case .update(let endPoint):
                return "/\(endPoint)"
            case .empty:
                return ""
            }
        }
    }
    
    enum Method: String {
        case GET
        case POST
        case PATCH
        case PUT
    }
    
    public init() { }
    
    func request<T: Codable>(endpoint: Endpoint,
                             method: Method,
                             params: [String: Any],
                             completion: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(baseURL)\(Endpoint.getEndPoint(endpoint))"
        guard let url = URL(string: path) else { completion(.failure(.internalError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        switch method {
        case .PUT, .POST, .PATCH:
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        default: break
        }
        
        call(with: request, completion: completion)
    }
    
    func call<T: Codable>(with request: URLRequest,
                          completion: @escaping((Result<T, APIError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { completion(.failure(.serverError)); return }
            do {
                guard let data = data else { completion(.failure(.serverError)); return }
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(object))
            } catch {
                completion(Result.failure(.parsingError))
            }
        }
        dataTask.resume()
    }
}

// MARK: ContactsFetchProvider
extension NetworkAPI: ContactsFetchProvider {
    func fetchContacts(completion: @escaping ((Result<ContactsResponse, APIError>) -> Void)) {
        request(endpoint: .perPage(endPoint: "10"), method: .GET, params: [:], completion: completion)
    }
}

// MARK: ContactCreateProvider
extension NetworkAPI: ContactCreateProvider {
    func createContact(name: String,
                       job: String,
                       completion: @escaping ((Result<ContactsResponse, APIError>) -> Void)) {
        let params = ["name": name, "job": job]
        request(endpoint: .empty, method: .GET, params: params, completion: completion)
    }
}


// MARK: ContactUpdateProvider
extension NetworkAPI: ContactUpdateProvider {
    func updateContact(userId: String,
                       name: String,
                       job: String,
                       completion: @escaping ((Result<UpdateResponse, APIError>) -> Void)) {
        let params = ["name": name, "job": job]
        request(endpoint: .update(endPoint: userId), method: .GET, params: params, completion: completion)
    }
}
