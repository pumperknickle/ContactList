import SwiftUI
import Combine
import ContactListModels

public final class ContactListViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    let searchSubject = PassthroughSubject<String, Never>()

    var query: String = "" {
        willSet {
            DispatchQueue.main.async {
                self.searchSubject.send(newValue)
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.onUpdateText(text: self.query)
                self.getContacts()
            }
        }
    }

    var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    var contactsCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    deinit {
        searchCancellable?.cancel()
        contactsCancellable?.cancel()
    }

    public init() {
        contactsCancellable = ContactAPI.getAllContacts()
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }) { (received) in
                self.contacts = received
        }
        searchCancellable = searchSubject
            .eraseToAnyPublisher().map { $0 }
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { (searchText) in
                self.onUpdateTextDebounced(text: searchText)
            })
    }
    
    func getContacts() {
        if query == "" {
            self.contactsCancellable = ContactAPI.getAllContacts()
                .sink(receiveCompletion: { (error) in
                    print(error)
                    return
                }) { (received) in
                    self.contacts = received
            }
        }
        else {
            self.contactsCancellable = ContactAPI.search(term: query)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (error) in
                    print(error)
                    return
                }) { (received) in
                    self.contacts = received
            }
        }
    }

    func onUpdateText(text: String) {
        print("Text Updated: " + text)
    }

    func onUpdateTextDebounced(text: String) {
        print("Update Text Debounced: " + text)
    }
}
