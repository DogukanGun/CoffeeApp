//
//  LoginView.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 27.02.2022.
//

import SwiftUI

struct LoginView: View {
    
    @State var showSignup = false
    @State var showFinishReg = false
    
    @Environment(\.isPresented) var presented
    
    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    
    var body: some View {
        VStack{
            Text(showSignup ? "Sign In" : "Sign Up")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.bottom,.top],20)
            VStack{
                VStack(alignment: .leading){
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label))
                        .opacity(0.75)
                    
                    TextField("Enter your email", text:$email)
                    Divider()
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label))
                        .opacity(0.75)
                    
                    SecureField("Enter your password", text:$password)
                    Divider()
                    if showSignup{
                        Text("Repeat Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label))
                            .opacity(0.75)
                        
                        SecureField("Enter your password again", text:$repeatPassword)
                        Divider()
                    }
                }.padding(.bottom,15)
                HStack{
                    Spacer()
                    Button {
                        resetPassword()
                    } label: {
                        Text("Reset Password ")
                            .foregroundColor(Color.gray.opacity(0.75))
                    }

                }
            }.padding(.horizontal,5)
            
            Button {
                showSignup ? signIn() : signUp()
            } label: {
                Text(showSignup ? "Sign In" : "Sign Up")
                    .foregroundColor(Color.white)
                    .frame(width:CGFloat(UIScreen.main.bounds.width)-120)
                    .padding()
            }
            .background(Color.blue)
            .clipShape(Capsule())
            .padding(.top,40)

            SignUpView(showSignUp: $showSignup)
        }.sheet(isPresented: $showFinishReg, onDismiss: nil) {
            FinishRegistirationView(dismissSheet: $showFinishReg)
        }
    }
    
    private func resetPassword(){
        if !email.isEmpty{
            FUser.resetPassword(email: email) { error in
                if error != nil{
                    print(error)
                    return
                }
                
                print("message is sended")
            }
        }
    }
    
    private func signUp(){
        if !email.isEmpty && !password.isEmpty {
            FUser.loginUserWith(email: self.email, password: self.password) { error, isEmailVerified in
                if let error = error {
                    return
                }
                if FUser.currentUser() != nil && FUser.currentUser()!.onBoard{
                    
                }else{
                    self.showFinishReg.toggle()
                }
            }
        }
        
    }
    
    private func signIn(){
        if !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty{
            FUser.registerUserWith(email: email, password: password) { error in
                
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
