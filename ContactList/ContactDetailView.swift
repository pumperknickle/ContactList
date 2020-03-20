import Foundation
import SwiftUI
import ContactListModels

struct ContactDetailView: View {
    let contact: Contact
    @ObservedObject var viewModel: ContactDetailViewModel
    @State private var show_modal: Bool = false
    
    init(contact: Contact) {
        self.contact = contact
        self.viewModel = ContactDetailViewModel(contactID: contact.id!)
    }

    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("Phone Numbers")
                }
                List(viewModel.phoneNumbers) { phone in
                    PhoneRow(phone: phone)
                }
                HStack {
                    Spacer()
                    Button("Add Phone") {
                        
                    }
                    Spacer()
                }
            }
            Section {
                Spacer().frame(height: 20)
                HStack {
                    Text("Phone Numbers")
                }
                List(viewModel.addresses) { address in
                    AddressRow(address: address)
                }
                HStack {
                    Spacer()
                    Button("Add Address") {
                        
                    }
                    Spacer()
                }
            }
            Section {
                Spacer().frame(height: 20)
                HStack {
                    Text("Dates")
                }
                List(viewModel.dates) { date in
                    DateRow(date: date)
                }
                HStack {
                    Spacer()
                    Button("Add Date") {
                        
                    }
                    Spacer()
                }
            }
            }
        .navigationBarItems(
            trailing:
            Button(action:
            {
                self.show_modal.toggle()
            },
            label: {
                Text("Edit")
            })
            )
            .navigationBarTitle(Text(contact.fullName()))
            .sheet(isPresented: self.$show_modal) {
                EditContactView(id: self.contact.id, f_name: self.contact.f_name, m_name: self.contact.m_name, l_name: self.contact.l_name)
            }
    }
}

extension Address: Identifiable { }
