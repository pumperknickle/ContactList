import SwiftUI
import ContactListModels
import Combine

struct EditContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var id: Int?
    @State var f_name: String
    @State var m_name: String
    @State var l_name: String

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First Name", text: $f_name)
                    TextField("Middle Name", text: $m_name)
                    TextField("Last Name", text: $l_name)
                }
            }
        .navigationBarItems(leading:
            Button(action:
            {
                self.presentationMode.wrappedValue.dismiss()
            },
            label: {
                Text("Cancel")
            }),
            trailing:
            Button(action:
            {
                ContactAPI.saveContact(
                    contact: Contact(id: self.id, f_name: self.f_name, m_name: self.m_name, l_name: self.l_name),
                    completion: { _ in self.presentationMode.wrappedValue.dismiss() }
                )
            },
            label: {
                Text("Save")
            })
            )
            .navigationBarTitle(Text("New Contact"))
        }
    }
}
