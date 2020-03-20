import SwiftUI
import ContactListModels

struct AddressRow: View {
    let address: Address!
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            Text(address.toString())
            Spacer()
        }
    }
}

extension Address {
    func toString() -> String {
        return "\(address_type.toString()): \(address) \(city), \(state) \(zip)"
    }
}

extension AddressType {
    func toString() -> String {
        switch self {
        case .HOME:
            return "Home"
        case .WORK:
            return "Work"
        default:
            return "Other"
        }
    }
}
