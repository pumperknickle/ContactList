import SwiftUI
import Combine
import ContactListModels

public final class ContactDetailViewModel: ObservableObject {
    @Published var phoneNumbers: [Phone] = [] {
        didSet {
            print(oldValue)
        }
    }
    @Published var addresses: [Address] = []
    @Published var dates: [ContactListModels.Date] = []
    
    var contactID: Contact.ID! {
        didSet {
            updateAll()
        }
    }
    
    var phonesCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    var addressesCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    var datesCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    deinit {
        phonesCancellable?.cancel()
        addressesCancellable?.cancel()
        datesCancellable?.cancel()
    }
    
    public init(contactID: Contact.ID) {
        self.contactID = contactID
    }
    
    func updateAll() {
        self.phonesCancellable = ContactAPI.getPhones(for: String(describing: contactID))
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (phones) in
                self.phoneNumbers = phones
            })
        self.addressesCancellable = ContactAPI.getAddresses(for: String(describing: contactID))
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (addresses) in
                self.addresses = addresses
            })
        self.datesCancellable = ContactAPI.getDates(for: String(describing: contactID))
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (dates) in
                self.dates = dates
            })
    }
}
