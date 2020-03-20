import Foundation
import Combine
import ContactListModels

enum ContactAPI {
    static let agent = Agent()
    static let base = URL(string: "http://0.0.0.0:8080")!
}

extension ContactAPI {
//    static func saveContact(contact: Contact) -> AnyPublisher<Contact, Error> {
//        if let contactID = contact.id {
//            // update contact
//            let suffix = "Contact/\(contactID)/"
//            var request = URLRequest(url: base.appendingPathComponent(suffix))
//            request.httpMethod = "PUT"
//            request.httpBody = try? JSONEncoder().encode(contact)
//            return run(request)
//        }
//        else {
//            // new contact
//            let suffix = "Contact/"
//            var request = URLRequest(url: base.appendingPathComponent(suffix))
//            request.httpMethod = "POST"
//            request.httpBody = try? JSONEncoder().encode(contact)
//            return run(request)
//        }
//        
//    }
    
    static func saveContact(contact: Contact, completion: @escaping (Contact) -> ()) {
        let isEdit = contact.id != nil
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = isEdit ? "Contact/\(contact.id!)/" : "Contact/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = isEdit ? "PUT" : "POST"
        request.httpBody = try? JSONEncoder().encode(contact)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            guard let savedContact = try? JSONDecoder().decode(Contact.self, from: data) else {
                return
            }
            completion(savedContact)
        }.resume()
    }
    
    static func getAllContacts() -> AnyPublisher<[Contact], Error> {
        let request = URLRequest(url: base.appendingPathComponent("Contact/"))
        return run(request)
    }
    
    static func getPhones(for contactID: String) -> AnyPublisher<[Phone], Error> {
        let request = URLRequest(url: base.appendingPathComponent("Phone/" + contactID))
        return run(request)
    }
    
    static func getAddresses(for contactID: String) -> AnyPublisher<[Address], Error> {
        let request = URLRequest(url: base.appendingPathComponent("Address/" + contactID))
        return run(request)
    }
    
    static func getDates(for contactID: String) -> AnyPublisher<[ContactListModels.Date], Error> {
        let request = URLRequest(url: base.appendingPathComponent("Date/" + contactID))
        return run(request)
    }
    
    static func search(term: String) -> AnyPublisher<[Contact], Error> {
        let request = URLRequest(url: base.appendingPathComponent("search/\(term)"))
        return run(request)
    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
