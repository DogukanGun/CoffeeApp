//
//  SignUpView.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 27.02.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @Binding var showSignUp: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing:8){
                Text("Don't you have an account ?")
                    .foregroundColor(Color.gray.opacity(0.8))
                Button {
                    self.showSignUp.toggle()
                } label: {
                    Text("Sign Up")
                }
                .foregroundColor(Color.blue)

            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider { 
    static var previews: some View {
        SignUpView(showSignUp: .constant(true))
    }
}
