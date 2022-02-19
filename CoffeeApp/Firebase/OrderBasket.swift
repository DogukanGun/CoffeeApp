//
//  OrderBasket.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import Foundation
import Firebase

class OrderBasket: Identifiable{
    
    var id:String = ""
    var ownerId:String = ""
    var items:[Drink] = []
    
    var total:Double{
        if items.count > 0 {
            return items.reduce(0){$0 + $1.price}
        }
        return 0.0
    }
    
    func add(_ item:Drink){
        items.append(item)
    }
    
    func remove(_ item:Drink){
        if let index = items.firstIndex(of: item){
            items.remove(at: index)
        }
    }
    
    func emptyBasket(){
        self.items = []
        saveBasketToFirebase()
    }
    
    func saveBasketToFirebase(){
        FirebaseReferance(.Basket).document(self.id).setData(basketToDictinionaryFrom(self))
    }
    
}

func basketToDictinionaryFrom(_ basket: OrderBasket) -> [String:Any] {
    var allDrinksId = [String]()
    
    for drink in basket.items {
        allDrinksId.append(drink.id)
    }
    
    return NSDictionary(objects: [basket.id,
                                  basket.ownerId,
                                 allDrinksId], forKeys: [kID as NSCopying,
                                                        kOWNERID as NSCopying,
                                                         kDRINKS as NSCopying]) as! [String : Any]
    
}
