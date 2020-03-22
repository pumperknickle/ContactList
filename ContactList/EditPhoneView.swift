import SwiftUI
import ContactListModels
import Combine

struct EditPhoneView: View {
    let contactID: Contact.ID!
    @Binding var sheet: Sheet?
    @State var id: Phone.ID = nil
    @State var phone_type: PhoneType = PhoneType.HOME
    @State var area_code: String = ""
    @State var number: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $phone_type, label: Text("Type")) {
                        ForEach(PhoneType.allCases) { phoneType in
                            Text(phoneType.toString())
                        }
                    }.pickerStyle(WheelPickerStyle())
                    TextField("Area Code", text: $area_code)
                    TextField("Number", text: $number)
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
                ContactAPI.savePhone(phone: Phone(id: self.id, contact_id: self.contactID!, phone_type: self.phone_type, area_code: self.area_code, number: self.number)) { _ in self.sheet = nil }

            },
            label: {
                Text("Save")
            })
            )
            .navigationBarTitle(Text("Phone Number Form"))
        }
    }
}
