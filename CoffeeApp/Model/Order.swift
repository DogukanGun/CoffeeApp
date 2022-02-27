//
//  Order.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 19.02.2022.
//

import Foundation


class Order: Identifiable{
    var id: String!
    var customerId: String!
    var orderItems: [Drink] = []
    var amount: Double!
    
    func saveOrderToFirestore(){
        FirebaseReferance(.Order).document(self.id).setData(orderDictionaryFrom(self))
    }
    
    
}

func orderDictionaryFrom(_ order:Order) -> [String:Any]{
    var allDrinksId = [String]()
    for drink in order.orderItems {
        allDrinksId.append(drink.id)
    }
    
    return NSDictionary(objects: [order.id,
                                  order.customerId,
                                  allDrinksId,
                                  order.amount], forKeys: [kID as NSCopying,
                                                           kCUSTOMERID as NSCopying,
                                                           kDRINKS as NSCopying,
                                                           kAMOUNT as NSCopying]) as! [String:Any]
    
}
