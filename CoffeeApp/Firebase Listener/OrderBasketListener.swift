//
//  OrderBasketListener.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import Foundation
import Firebase

class OrderBasketListener: ObservableObject{
    @Published var orderBasket:OrderBasket!
    
    init(){
        downloadBasket()
    }
    
    func downloadBasket(){
        if FUser.currentId() != nil{
            FirebaseReferance(.Basket).whereField(kOWNERID, isEqualTo: FUser.currentId()).addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                
                if !snapshot.isEmpty{
                    let basketData = snapshot.documents.first!.data()
                    getDrinksFromFirestore(withIds: basketData[kDRINKS] as? [String] ?? []) { drinkArray in
                        let orderBasket = OrderBasket()
                        orderBasket.ownerId = basketData[kOWNERID] as? String ?? ""
                        orderBasket.id = basketData[kID] as? String ?? ""
                        orderBasket.items = drinkArray
                        self.orderBasket = orderBasket
                    }
                }
                
            }
        } 
    }
}

func getDrinksFromFirestore(withIds: [String],completation: @escaping (_ drinkArray:[Drink])->Void){
    var count = 0
    var drinkArray = [Drink]()
    
    if withIds.isEmpty{
        completation(drinkArray)
        return
    }
    
    for id in withIds {
        FirebaseReferance(.Menu).whereField(kID, isEqualTo: id).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }

            if !snapshot.isEmpty{
                let drinkData = snapshot.documents.first!.data()
                let drink = Drink(id: drinkData[kID] as? String ?? UUID().uuidString, name: drinkData[kNAME] as? String ?? "Unknown", imageName: drinkData[kIMAGENAME] as? String ?? "Unknown", category: Category.init(rawValue: drinkData[kCATEGORY] as? String ?? "cold") ?? .cold, description: drinkData[kDESCRIPTION] as? String ?? "", price: drinkData[kPRICE] as? Double ?? 0.0)
                drinkArray.append(drink)
                count+=1
            }else{
                completation(drinkArray)
            }
            
            
            if count == withIds.count{
                completation(drinkArray)
            }
        }
    }
}
