//
//  DrinkDetail.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import SwiftUI

struct DrinkDetail: View {
    var drink:Drink
    @State private var showingAlert = false
    var body: some View {
        ScrollView(.vertical){
            ZStack(alignment: .bottom){
                Image(drink.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Rectangle()
                    .frame(height: 80)
                    .opacity(0.5)
                    .blur(radius: 10)
                HStack(alignment: .center) {
                    Text(drink.name)
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.bottom)
                    .padding(.leading)
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets())
            
            Text(drink.description)
                .font(.body)
                .lineLimit(5)
                .padding()
            
            HStack{
                Spacer()
                OrderButton(showingAlert:$showingAlert, drink: drink, buttonText: "Add Basket")
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert("Adding to Basket",isPresented: $showingAlert) {
            Button {
                print("Button pressed")
            } label: {
                Text("Okay")
            }

        }
    }
}

struct OrderButton: View{
    @Binding var showingAlert: Bool
    @ObservedObject var basketListener = OrderBasketListener()
    var drink:Drink
    var buttonText: String
    var body: some View{
        HStack{
            Button {
                self.showingAlert.toggle()
                addBasket()
            } label: {
                Text(buttonText)
            }
            .frame(width: 200, height: 50)
            .foregroundColor(.white)
            .font(.headline)
            .background(Color.blue)
            .cornerRadius(15)

        }
    }
    
    private func addBasket(){
        var orderBasket: OrderBasket!
        
        if basketListener.orderBasket != nil{
            orderBasket = basketListener.orderBasket
        }else{
            orderBasket = OrderBasket()
            orderBasket.ownerId = "123"
            orderBasket.id = UUID().uuidString
            
        }
        orderBasket.add(drink)
        orderBasket.saveBasketToFirebase()
        
    }
}



struct OrderButton_Previews: PreviewProvider {
    @State static var value = false

    static var previews: some View {
        OrderButton(showingAlert:$value, drink: drinkData.first!, buttonText: "Add Basket")
    }
}


struct DrinkDetail_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetail(drink: drinkData.first!)
    }
}
