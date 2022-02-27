//
//  CoffeeHomePageView.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 18.02.2022.
//

import SwiftUI

struct CoffeeHomePageView: View {
    
    @ObservedObject var drinkListener = DrinkListener()
    @State var showingBasket = false
    @State var setError = false

    var categories: [String : [Drink]]{
        .init(grouping: drinkListener.drinks) {$0.category.rawValue}
    }
    var body: some View {
        NavigationView{
            List(categories.keys.sorted(),id: \String.self){ key in
                CoffeeRow(categoryName: key, drink: categories[key]!)
                    .frame(height: 320)
                    .padding(.top)
                    .padding(.bottom)
            }
            .navigationTitle("Coffee Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        FUser.logoutCurrentUser { error in
                            if error != nil {
                              print(error)
                            }
                        }
                    } label: {
                        Text("Log Out")
                    }.alert("Oppps",isPresented: $setError) {
                        Button {
                            setError.toggle()
                        } label: {
                            Text("Okay")
                        }
                    }

                }
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button {
                        showingBasket.toggle()
                    } label: {
                        Image("basket")
                    }
                    
                }
            }
        }.sheet(isPresented: $showingBasket, onDismiss: nil) {
            if FUser.currentUser() != nil && FUser.currentUser()?.onBoard == true{
                OrderBasketView()
            }else if FUser.currentUser() != nil{
                FinishRegistirationView(dismissSheet: $showingBasket)
            }else{
                LoginView()
            }
        }
    }
}


struct CoffeeRow: View{
    
    var categoryName:String
    var drink:[Drink]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(categoryName.uppercased())
                .font(.title)
                .padding(.top)
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(drink){ drink in
                        NavigationLink(destination: DrinkDetail(drink: drink)){
                            DrinkItem(drink: drink)
                                .frame(width:320)
                                .padding(.trailing,30)
                        }
                    }
                }
            }
        }
    }
}

struct CoffeeRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeRow(categoryName: "Test", drink: drinkData)
    }
}
struct CoffeeHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeHomePageView()
    }
}
