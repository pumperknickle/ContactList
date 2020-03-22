import SwiftUI
import ContactListModels
import Combine

struct EditAddressView: View {
    let contactID: Contact.ID!
    @Binding var sheet: Sheet?
    @State var id: Address.ID = nil
    @State var address_type: AddressType = AddressType.HOME
    @State var address: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var zip: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $address_type, label: Text("Type")) {
                        ForEach(AddressType.allCases) { addressType in
                            Text(addressType.toString())
                        }
                    }.pickerStyle(WheelPickerStyle())
                    TextField("Street Address", text: $address)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Zip", text: $zip)
                }
            }
        .navigationBarItems(leading:
            Button(action:
            {
                self.sheet = nil
            },
            label: {
                Text("Cancel")
            }),
            trailing:
            Button(action:
            {
                ContactAPI.saveAddress(address: Address(id: self.id, contact_id: self.contactID!, address_type: self.address_type, address: self.address, city: self.city, state: self.state, zip: self.zip)) { _ in self.sheet = nil }
            },
            label: {
                Text("Save")
            })
            )
            .navigationBarTitle(Text("Address Form"))
        }
    }
}
