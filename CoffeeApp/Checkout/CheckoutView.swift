//
//  CheckoutView.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import SwiftUI
import AVFoundation

struct CheckoutView: View {
    
    @ObservedObject var basketListener = OrderBasketListener()
    
    static let paymentTypes = ["Credit Card","Cash"]
    static let tipAmounts = [10,15,20,0]
    
    @State private var paymentType = 0
    @State private var tipType = 0
    @State private var showPaymentPage = false
    
    var totalPrice: Double{
        let price = basketListener.orderBasket?.total
        let priceWithTip = price ?? 1.0/Double(100*CheckoutView.tipAmounts[tipType])
        if let price = price{
            return priceWithTip + price
        }
        return 0.0
    }
    
    var body: some View {
        Form{
            Section{
                Picker("How do yo want to select ?",selection: $paymentType) {
                    ForEach(0..<CheckoutView.paymentTypes.count) { index in
                        Text(CheckoutView.paymentTypes[index])
                    }
                }
            }
            Section{
                Picker("Tip Amount",selection: $tipType) {
                    ForEach(0..<CheckoutView.tipAmounts.count) { index in
                        Text("\(CheckoutView.tipAmounts[index]) %")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Button {
                    self.showPaymentPage.toggle()
                    createOrder()
                    deleteBasket()
                } label: {
                    Text("Confirm Order")
                } 
            } header: {
                Text("Total price \(String(format: "%.2f", totalPrice))")
                    .font(.largeTitle)
            }.disabled(self.basketListener.orderBasket?.items.isEmpty ?? true)

        }
        .navigationTitle("Payment")
        .alert("Order Complete",isPresented: $showPaymentPage) {
            Button {
                print("Order Complete")
            } label: {
                Text("Okay")
            }

        }
    }
    
    func createOrder(){
        let order = Order()
        order.id = UUID().uuidString
        order.amount = totalPrice
        order.customerId = "123"
        order.orderItems = basketListener.orderBasket?.items ?? []
        order.saveOrderToFirestore()
    }
    
    func deleteBasket(){
        self.basketListener.orderBasket?.emptyBasket()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
