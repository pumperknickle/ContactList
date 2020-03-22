import SwiftUI
import Combine
import ContactListModels

public final class ContactDetailViewModel: ObservableObject {
    @Published var phoneNumbers: [Phone] = []
    @Published var addresses: [Address] = []
    @Published var dates: [ContactListModels.Date] = []
    @Published var contact: Contact
    var contactID: Contact.ID! {
        return contact.id!
    }
    var phone: Phone? = nil
    var address: Address? = nil
    var date: ContactListModels.Date? = nil
    
    var contactCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
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
    
    public init(contact: Contact) {
        self.contact = contact
        self.updateAll()
    }
    
    deinit {
        phonesCancellable?.cancel()
        addressesCancellable?.cancel()
        datesCancellable?.cancel()
        contactCancellable?.cancel()
    }
    
    func updateAll() {
        self.contactCancellable = ContactAPI.getContact(for: "\(contactID! ?? Int.max)")
        .sink(receiveCompletion: { (error) in
            print(error)
            return
        }, receiveValue: { (contact) in
            self.contact = contact
        })
        self.phonesCancellable = ContactAPI.getPhones(for: "\(contactID! ?? Int.max)")
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (phones) in
                self.phoneNumbers = phones
            })
        self.addressesCancellable = ContactAPI.getAddresses(for: "\(contactID! ?? Int.max)")
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (addresses) in
                self.addresses = addresses
            })
        self.datesCancellable = ContactAPI.getDates(for: "\(contactID! ?? Int.max)")
            .sink(receiveCompletion: { (error) in
                print(error)
                return
            }, receiveValue: { (dates) in
                self.dates = dates
            })
    }
}
