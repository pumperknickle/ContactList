import SwiftUI
import Combine
import ContactListModels

struct PhoneListView: View {
    @ObservedObject var viewModel: PhoneListViewModel
    @State private var show_modal: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.phones) { phone in
                    PhoneRow(phone: phone)
                }
                .navigationBarItems(trailing:
                    Button(action: {
                        self.show_modal.toggle()
                        }, label: {
                            Text("New")
                        })
                )
                .navigationBarTitle(Text("Phones"))
            }
        }
    }
}

extension Phone: Identifiable { }
