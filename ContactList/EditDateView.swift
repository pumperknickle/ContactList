import SwiftUI
import ContactListModels
import Combine
import Foundation

struct EditDateView: View {
    let contactID: Contact.ID!
    @Binding var sheet: Sheet?
    @State var id: ContactListModels.Date.ID = nil
    @State var date_type: DateType = DateType.ANNIVERSARY
    @State var calendar_date: Foundation.Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $date_type, label: Text("Type")) {
                        ForEach(DateType.allCases) { dateType in
                            Text(dateType.toString())
                        }
                    }.pickerStyle(WheelPickerStyle())
                    DatePicker(selection: $calendar_date, in: ...Date(), displayedComponents: .date) {
                        Text("Select a date")
                    }
                }
            }
        .navigationBarItems(leading:
            Button(action:
            {
                self.sheet = nil
            },
            label: {
                Text("Cancel")
            }),
            trailing:
            Button(action:
            {
                ContactAPI.saveDate(date: ContactListModels.Date(id: self.id, contact_id: self.contactID!, date_type: self.date_type, calendar_date: self.calendar_date.toString())) { _ in self.sheet = nil }
            },
            label: {
                Text("Save")
            })
            )
            .navigationBarTitle(Text("Date Form"))
        }
    }
}

extension Foundation.Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Foundation.Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)!
    }
}
