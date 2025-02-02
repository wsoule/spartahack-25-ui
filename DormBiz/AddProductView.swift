import SwiftUI
import CoreLocation
import MapKit

struct AddProductView: View {
    @Binding var establishment: Establishment
    @Environment(\.dismiss) private var dismiss

    @State private var productName: String = ""
    @State private var productCost: Decimal = 0.0
    @State private var productDescription: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Name", text: $productName)
                    TextField("Cost", value: $productCost, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $productDescription)
                }
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addProduct()
                        dismiss()
                    }
                    .disabled(productName.isEmpty || productCost <= 0)
                }
            }
        }
    }

    private func addProduct() {
        let newProduct = Product(
            name: productName,
            cost: NSDecimalNumber(decimal: productCost).doubleValue,
            description: productDescription
        )
        establishment.products.append(newProduct)
    }
}
