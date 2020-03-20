import SwiftUI
import Combine
import ContactListModels

struct ContactListView: View {
    @ObservedObject var viewModel: ContactListViewModel
    @State private var show_modal: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.query)
                List(viewModel.contacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                        ContactRow(contact: contact)
                    }
                }
                .navigationBarTitle(Text("Contacts"))
            }.navigationBarItems(trailing:
                Button(action: {
                    self.show_modal.toggle()
                    }, label: {
                        Text("New")
                    })
            )
        }
        .sheet(isPresented: self.$show_modal, onDismiss: {
            self.viewModel.getContacts()
        },
        content: {
            EditContactView(f_name: "", m_name: "", l_name: "")
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
