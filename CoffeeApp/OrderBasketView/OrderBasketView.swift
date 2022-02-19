//
//  OrderBasket.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import SwiftUI

struct OrderBasketView: View {
    @ObservedObject var basketListener = OrderBasketListener()
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    ForEach(self.basketListener.orderBasket?.items ?? [] ){ drink in
                        HStack{
                            Text(drink.name)
                            Text("$\(drink.price)")
                        }
                    }.onDelete { index in
                        deleteItem(at: index)
                    }
                }
                
                Section{
                    NavigationLink(destination: CoffeeHomePageView()){
                        
                        Text("Place Order")
                    }
                    
                }.disabled(self.basketListener.orderBasket?.items.isEmpty ?? false)
            }
            .navigationTitle("Basket")
            .listStyle(GroupedListStyle())
        }
    }
    
    func deleteItem(at index:IndexSet){
        self.basketListener.orderBasket?.items.remove(at: index.first!)
        self.basketListener.orderBasket.saveBasketToFirebase()
    }
}

struct OrderBasketView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBasketView()
    }
}
