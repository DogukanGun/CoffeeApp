//
//  DrinkItem.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 18.02.2022.
//

import SwiftUI

struct DrinkItem: View {
    var drink:Drink
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: CGFloat(16)){
                Image(drink.imageName)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height/3)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                VStack(alignment: .leading, spacing: CGFloat(5)){
                        Text(drink.name)
                        .foregroundColor(.primary)
                        .font(.title)
                        Text(drink.description)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(height: proxy.size.height/10)
                    }
            }
            
        }
    }
}

struct DrinkItem_Previews: PreviewProvider {
    static var previews: some View {
        DrinkItem(drink: drinkData[0])
    }
}
