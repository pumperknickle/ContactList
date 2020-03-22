import SwiftUI
import Combine
import ContactListModels

struct ContactListView: View {
    @ObservedObject var viewModel: ContactListViewModel
    @State private var sheet: Sheet? = nil
    
    func onDeleteRow(indices: IndexSet) {
        let contacts = indices.map { viewModel.contacts[$0] }
        delete(contacts: contacts)
    }
    
    func delete(contacts: [Contact]) {
        guard let firstContact = contacts.first else { return }
        ContactAPI.deleteContact(contact: firstContact) {
            self.viewModel.getContacts()
        }
        delete(contacts: Array(contacts.dropFirst()))
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.query)
                List {
                    ForEach (viewModel.contacts) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact).onDisappear(perform: {
                            self.viewModel.getContacts()
                        })
                        ) {
                            ContactRow(contact: contact)
                        }
                    }.onDelete(perform: onDeleteRow)
                }
                .navigationBarTitle(Text("Contacts"))
            }.navigationBarItems(trailing:
                Button(action: {
                    self.sheet = .CONTACT
                    }, label: {
                        Text("New")
                    })
            )
        }
        .sheet(item: self.$sheet, onDismiss: {
            self.viewModel.getContacts()
        },
        content: { _ in
            EditContactView(sheet: self.$sheet, f_name: "", m_name: "", l_name: "")
        })
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        let contactList = [Contact(f_name: "John", m_name: "M", l_name: "Doe"), Contact(f_name: "Jeff", m_name: "X", l_name: "Doe")]
        return ContactListView(viewModel: ContactListViewModel())
    }
}

extension Contact: Identifiable { }

struct SearchBar: UIViewRepresentable {

    var cancellable: AnyCancellable?
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
