import SwiftUI
import ContactListModels

struct ContactRow: View {
    let contact: Contact!
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            Text(contact.fullName())
            Spacer()
        }
        
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(contact: Contact(f_name: "John", m_name: "M", l_name: "Doe"))
    }
}

extension Contact {
    func fullName() -> String {
        return "\(f_name!) \(m_name!) \(l_name!)"
    }
}
