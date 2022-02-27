//
//  FinishRegistiration.swift
//  CoffeeApp
//
//  Created by Dogukan Gundogan on 27.02.2022.
//

import SwiftUI

struct FinishRegistirationView: View {
    @Binding var dismissSheet: Bool

    @State var name = ""
    @State var username = ""
    @State var telephone = ""
    @State var address = ""
    
    
    var body: some View {
        Form{
            Section(){
                Text("Finish Registration")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.bottom,.top],20)
                TextField("Name",text: $name)
                TextField("Username",text: $username)
                TextField("Telephone",text: $telephone)
                TextField("Address",text: $address)
            }
            
            Section(){
                Button {
                    self.finishRegistration()
                } label: {
                    Text("Finish Registraion")
                }.disabled(!self.isEnable())
            }
        }
    }
    
    private func isEnable()->Bool{
        return self.name != "" && self.username != "" && self.telephone != "" && self.address != ""
    }
    
    private func finishRegistration(){
        let fullName = "\(name) \(username)"
        updateUser(withValues: [kFIRSTNAME:name,kLASTNAME:username,kFULLNAME:fullName,kPHONE:telephone,kADDRESS:address,kONBOARD:true]) { error in
            
            if let error = error {
                print(error)
                return
            } 
            
        }
    }
}

struct FinishRegistirationView_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistirationView(dismissSheet: .constant(true))
    }
}
