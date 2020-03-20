import SwiftUI
import ContactListModels

struct DateRow: View {
    let date: ContactListModels.Date!
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            Text(date.toString())
            Spacer()
        }
    }
}

extension ContactListModels.Date: Identifiable { }

extension ContactListModels.Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "\(date_type.toString()): \(formatter.string(from: calendar_date))"
    }
}

extension DateType {
    func toString() -> String {
        switch self {
        case .ANNIVERSARY:
            return "Anniversary"
        case .BIRTHDAY:
            return "Birthday"
        default:
            return "Other"
        }
    }
}
