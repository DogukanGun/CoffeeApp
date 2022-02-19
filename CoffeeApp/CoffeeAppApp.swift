//
//  CoffeeAppApp.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 18.02.2022.
//

import SwiftUI
import Firebase

@main
struct CoffeeAppApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            CoffeeHomePageView()
        }
    }
}
