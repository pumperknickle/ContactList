import SwiftUI
import Combine
import ContactListModels

public final class PhoneListViewModel: ObservableObject {
    @Published var phones: [Phone] = []
    var contactID: Contact.ID!
    
    var phonesCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    deinit {
        phonesCancellable?.cancel()
    }

    public init(contactID: Contact.ID!) {
        self.contactID = contactID
        getPhones()
    }
    
    func getPhones() {
        phonesCancellable = ContactAPI.getPhones(for: String(describing: contactID))
        .sink(receiveCompletion: { (error) in
            print(error)
            return
        }) { (received) in
            self.phones = received
        }
    }

    /// Overwrite by your subclass to get instant text update.
    func onUpdateText(text: String) {

    }

    /// Overwrite by your subclass to get debounced text update.
    func onUpdateTextDebounced(text: String) {
    }
}
