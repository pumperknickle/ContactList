import SwiftUI
import ContactListModels

struct PhoneRow: View {
    let phone: Phone!
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            Text(phone.toString())
            Spacer()
        }
    }
}

struct PhoneRow_Previews: PreviewProvider {
    static var previews: some View {
        PhoneRow(phone: Phone(contact_id: 1, phone_type: .FAX, area_code: "214", number: "2131212"))
    }
}

extension Phone {
    func toString() -> String {
        return "\(phone_type.toString()): (\(area_code)) \(number)"
    }
}

extension PhoneType {
    func toString() -> String {
        switch self {
        case .FAX:
            return "Fax"
        case .HOME:
            return "Home"
        case .WORK:
            return "Work"
        default:
            return "Other"
        }
    }
}
