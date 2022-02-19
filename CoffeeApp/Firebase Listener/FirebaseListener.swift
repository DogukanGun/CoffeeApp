//
//  FirebaseListener.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 18.02.2022.
//

import Foundation
import Firebase


class DrinkListener: ObservableObject{
    @Published var drinks:[Drink] = []
    
    init(){
        downloadDrinks()
    }
    
    func downloadDrinks(){
        FirebaseReferance(.Menu).getDocuments{ (snapshot,error) in
            guard let snapshot = snapshot else {
                return
            }
            
            if !snapshot.isEmpty{
                self.drinks = self.getDictionaryFromSnapshot(snapshot)
            }
        }
    }
    
    private func getDictionaryFromSnapshot(_ snapshots:QuerySnapshot) -> [Drink]{
        var allDrinks:[Drink] = []
        
        for snapshot in snapshots.documents{
            let drinkData = snapshot.data()
            
            let drink = Drink(id: drinkData[kID] as? String ?? UUID().uuidString, name: drinkData[kNAME] as? String ?? "Unknown", imageName: drinkData[kIMAGENAME] as? String ?? "Unknown", category: Category.init(rawValue: drinkData[kCATEGORY] as? String ?? "cold") ?? .cold, description: drinkData[kDESCRIPTION] as? String ?? "", price: drinkData[kPRICE] as? Double ?? 0.0)
            allDrinks.append(drink)
        }
        
        return allDrinks
    }
}
