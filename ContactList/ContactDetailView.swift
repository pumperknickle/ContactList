import Foundation
import SwiftUI
import ContactListModels

struct ContactDetailView: View {
    @ObservedObject var viewModel: ContactDetailViewModel
    @State var activeSheet: Sheet? = nil
    
    func onDeletePhone(indices: IndexSet) {
        let phones = indices.map { viewModel.phoneNumbers[$0] }
        delete(phones: phones)
    }
    
    func delete(phones: [Phone]) {
        guard let firstPhone = phones.first else { return }
        ContactAPI.deletePhone(phone: firstPhone) {
            self.viewModel.updateAll()
        }
        delete(phones: Array(phones.dropFirst()))
    }
    
    func onDeleteAddress(indices: IndexSet) {
        let addresses = indices.map { viewModel.addresses[$0] }
        delete(addresses: addresses)
    }
    
    func delete(addresses: [Address]) {
        guard let firstAddress = addresses.first else { return }
        ContactAPI.deleteAddress(address: firstAddress) {
            self.viewModel.updateAll()
        }
        delete(addresses: Array(addresses.dropFirst()))
    }
    
    func onDeleteDate(indices: IndexSet) {
        let dates = indices.map { viewModel.dates[$0] }
        delete(dates: dates)
    }
    
    func delete(dates: [ContactListModels.Date]) {
        guard let firstDate = dates.first else { return }
        ContactAPI.deleteDate(date: firstDate) {
            self.viewModel.updateAll()
        }
        delete(dates: Array(dates.dropFirst()))
    }

    init(contact: Contact) {
        self.viewModel = ContactDetailViewModel(contact: contact)
    }

    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("Phone Numbers")
                }
                List {
                    ForEach (viewModel.phoneNumbers) { phone in
                        PhoneRow(phone: phone).onTapGesture {
                            self.viewModel.phone = phone
                            self.activeSheet = .PHONE
                        }
                    }.onDelete(perform: onDeletePhone)
                }
                HStack {
                    Spacer()
                    Button(action:
                    {
                        self.activeSheet = .PHONE
                    },
                    label: {
                        Text("Add Phone")
                    })
                    Spacer()
                }
            }
            Section {
                Spacer().frame(height: 20)
                HStack {
                    Text("Addresses")
                }
                List {
                    ForEach (viewModel.addresses) { address in
                        AddressRow(address: address).onTapGesture {
                            self.viewModel.address = address
                            self.activeSheet = .ADDRESS
                        }
                    }.onDelete(perform: onDeleteAddress)
                }
                HStack {
                    Spacer()
                    Button(action:
                    {
                        self.activeSheet = .ADDRESS
                    },
                    label: {
                        Text("Add Address")
                    })
                    Spacer()
                }
            }
            Section {
                Spacer().frame(height: 20)
                HStack {
                    Text("Dates")
                }
                List {
                    ForEach (viewModel.dates) { date in
                        DateRow(date: date).onTapGesture {
                            self.viewModel.date = date
                            self.activeSheet = .DATE
                        }
                    }.onDelete(perform: onDeleteDate)
                }
                HStack {
                    Spacer()
                    Button(action:
                    {
                        self.activeSheet = .DATE
                    },
                    label: {
                        Text("Add Date")
                    })
                    Spacer()
                }
            }
            }
        .navigationBarItems(
            trailing:
            Button(action:
            {
                self.activeSheet = .CONTACT
            },
            label: {
                Text("Edit")
            })
        )
.navigationBarTitle(Text(self.viewModel.contact.fullName()))
        .sheet(item: self.$activeSheet, onDismiss: {
            self.viewModel.updateAll()
        },
        content: { item in
            if self.activeSheet == .ADDRESS {
                if self.viewModel.address == nil {
                    EditAddressView(contactID: self.viewModel.contactID, sheet: self.$activeSheet)
                }
                else {
                    EditAddressView(contactID: self.viewModel.contactID, sheet: self.$activeSheet, id: self.viewModel.address!.id!, address_type: self.viewModel.address!.address_type, address: self.viewModel.address!.address ?? "", city: self.viewModel.address!.city ?? "", state: self.viewModel.address!.state ?? "", zip: self.viewModel.address!.zip ?? "").onDisappear {
                        self.viewModel.address = nil
                    }
                }
            }
            else if self.activeSheet == .PHONE {
                if self.viewModel.phone == nil {
                    EditPhoneView(contactID: self.viewModel.contactID, sheet: self.$activeSheet)
                }
                else {
                    EditPhoneView(contactID: self.viewModel.contactID, sheet: self.$activeSheet, id: self.viewModel.phone!.id!, phone_type: self.viewModel.phone!.phone_type, area_code: self.viewModel.phone!.area_code, number: self.viewModel.phone!.number).onDisappear {
                        self.viewModel.phone = nil
                    }
                }
            }
            else if self.activeSheet == .DATE {
                if self.viewModel.date == nil {
                    EditDateView(contactID: self.viewModel.contactID, sheet: self.$activeSheet)
                }
                else {
                    EditDateView(contactID: self.viewModel.contactID, sheet: self.$activeSheet, id: self.viewModel.date!.id!, date_type: self.viewModel.date!.date_type, calendar_date: self.viewModel.date!.calendar_date.toDate()).onDisappear {
                        self.viewModel.date = nil
                    }
                }
            }
            else {
                EditContactView(sheet: self.$activeSheet, id: self.viewModel.contactID, f_name: self.viewModel.contact.f_name, m_name: self.viewModel.contact.m_name ?? "", l_name: self.viewModel.contact.l_name)
            }
        })
    }
}

extension Address: Identifiable { }
extension Phone: Identifiable { }
extension ContactListModels.Date: Identifiable { }

enum Sheet: Hashable, Identifiable {

    case CONTACT, PHONE, ADDRESS, DATE

    var id: Int {
        return self.hashValue
    }

}
