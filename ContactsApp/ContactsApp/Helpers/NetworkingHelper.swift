
import Foundation

public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol ContactsProvider {
    func fetchContacts(completion: @escaping((Result<ContactsResponse, APIError>) -> Void))
}

public class NetworkAPI {
    private let baseURL = "https://reqres.in/api/users?per_page=10"
    
    enum Endpoint: String {
        case random = ""
    }
    
    enum Method: String {
        case GET
        case POST
    }
    
    public init() { }
    
    func request<T: Codable>(endpoint: Endpoint,
                             method: Method,
                             completion: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(baseURL)\(endpoint.rawValue)"
        guard let url = URL(string: path) else { completion(.failure(.internalError)); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
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

// MARK: ContactsProvider
extension NetworkAPI: ContactsProvider {
    func fetchContacts(completion: @escaping ((Result<ContactsResponse, APIError>) -> Void)) {
        request(endpoint: .random, method: .GET, completion: completion)
    }
}
