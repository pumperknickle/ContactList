import Foundation
import Combine
import ContactListModels

enum ContactAPI {
    static let agent = Agent()
    static let base = URL(string: "http://0.0.0.0:8080")!
}

extension ContactAPI {
    static func saveContact(contact: Contact, completion: @escaping (Contact) -> ()) {
        let isEdit = contact.id != nil
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Contact/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = isEdit ? "PUT" : "POST"
        let contactToSave = isEdit ? contact : Contact(id: Int.random(in: 1000...Int.max), f_name: contact.f_name, m_name: contact.m_name, l_name: contact.l_name)
        request.httpBody = try? JSONEncoder().encode(contactToSave)
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
    
    static func savePhone(phone: Phone, completion: @escaping (Phone) -> ()) {
        let isEdit = phone.id != nil
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Phone/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = isEdit ? "PUT" : "POST"
        let phoneToSave = isEdit ? phone : Phone(id: Int.random(in: 1000...Int.max), contact_id: phone.contact_id, phone_type: phone.phone_type, area_code: phone.area_code, number: phone.number)
        request.httpBody = try? JSONEncoder().encode(phoneToSave)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            guard let savedPhone = try? JSONDecoder().decode(Phone.self, from: data) else {
                return
            }
            completion(savedPhone)
        }.resume()
    }
    
    static func saveAddress(address: Address, completion: @escaping (Address) -> ()) {
        let isEdit = address.id != nil
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Address/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = isEdit ? "PUT" : "POST"
        let addressToSave = isEdit ? address : Address(id: Int.random(in: 1000...Int.max), contact_id: address.contact_id, address_type: address.address_type, address: address.address, city: address.city, state: address.state, zip: address.zip)
        request.httpBody = try? JSONEncoder().encode(addressToSave)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            guard let savedAddress = try? JSONDecoder().decode(Address.self, from: data) else {
                return
            }
            completion(savedAddress)
        }.resume()
    }
    
    static func saveDate(date: ContactListModels.Date, completion: @escaping (ContactListModels.Date) -> ()) {
        let isEdit = date.id != nil
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Date/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = isEdit ? "PUT" : "POST"
        let dateToSave = isEdit ? date : ContactListModels.Date(id: Int.random(in: 1000...Int.max), contact_id: date.contact_id, date_type: date.date_type, calendar_date: date.calendar_date)
        request.httpBody = try? JSONEncoder().encode(dateToSave)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            guard let savedDate = try? JSONDecoder().decode(ContactListModels.Date.self, from: data) else {
                return
            }
            completion(savedDate)
        }.resume()
    }
    
    static func deleteDate(date: ContactListModels.Date, completion: @escaping () -> ()) {
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Date/\(date.id!)/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error = error else {
                completion()
                return
            }
            print(error)
            return
        }.resume()
    }
    
    static func deletePhone(phone: Phone, completion: @escaping () -> ()) {
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Phone/\(phone.id!)/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error = error else {
                completion()
                return
            }
            print(error)
            return
        }.resume()
    }
    
    static func deleteAddress(address: Address, completion: @escaping () -> ()) {
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Address/\(address.id!)/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error = error else {
                completion()
                return
            }
            print(error)
            return
        }.resume()
    }
    
    static func deleteContact(contact: Contact, completion: @escaping () -> ()) {
        let base = URL(string: "http://0.0.0.0:8080")!
        let suffix = "Contact/\(contact.id!)/"
        var request = URLRequest(url: base.appendingPathComponent(suffix))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error = error else {
                completion()
                return
            }
            print(error)
            return
        }.resume()
    }
    
    static func getAllContacts() -> AnyPublisher<[Contact], Error> {
        let request = URLRequest(url: base.appendingPathComponent("Contact/"))
        return run(request)
    }
    
    static func getContact(for contactID: String) -> AnyPublisher<Contact, Error> {
        let request = URLRequest(url: base.appendingPathComponent("Contact/" + contactID))
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
