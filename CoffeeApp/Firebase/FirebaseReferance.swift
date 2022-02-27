//
//  FirebaseReferance.swift
//  PracticeSwfitUI
//
//  Created by Dogukan Gundogan on 18.02.2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReferance: String{
    case User
    case Menu
    case Order
    case Basket
}

func FirebaseReferance(_ collectionReferance: FCollectionReferance) ->CollectionReference{
    return Firestore.firestore().collection(collectionReferance.rawValue)
}
