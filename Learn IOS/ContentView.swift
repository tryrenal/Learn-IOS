//
//  ContentView.swift
//  Learn IOS
//
//  Created by redveloper on 3/8/25.
//

import SwiftUI

enum AuthType {
    case login
    case register
}

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var isEmailFocused
    @FocusState private var isPasswordFocused
    
    @State private var hasAgreedToTerm = false
    @State private var showPass = false
    @State private var authType: AuthType = .login
    
    var body: some View {
        ScrollView(showsIndicators: false){
            TopView()
            SegmentView(authType: $authType)
            
            VStack(spacing: 15){
                TextField(text: $email){
                    Text("Email")
                }
                .focused($isEmailFocused)
                ZStack{
                    TextField(text: $password){
                        Text("Password")
                    }
                    .focused($isPasswordFocused)
                    .textFieldStyle(AuthTextFieldStyle(isFocused: $isPasswordFocused))
                    .overlay(alignment: .trailing, content: {
                        Button{
                            withAnimation{
                                showPass.toggle()
                            }
                        }
                        label:{
                            Image(systemName: showPass ? "eye.fill" : "eye.slash.fill")
                                .padding()
                                .foregroundStyle(Color(uiColor: .lightGray))
                        }
                    })
                    .opacity(showPass ? 1:0)
                    .zIndex(1)
                    
                    SecureField(text: $password){
                        Text("Password")
                    }
                    .focused($isPasswordFocused)
                    .overlay(alignment: .trailing, content: {
                        Button{
                            withAnimation{
                                showPass.toggle()
                            }
                        }
                        label: {
                            Image(systemName: showPass ? "eye.fill" : "eye.slash.fill")
                                .padding()
                                .foregroundStyle(Color(uiColor: .lightGray))
                        }
                    })
                    .opacity(showPass ? 0 : 1)
                }
                
                if authType == .register {
                    HStack(alignment: .top){
                        Toggle(isOn: $hasAgreedToTerm){
                            
                        }
                        .toggleStyle(AgreeStyle())
                        Text("i agree to the terms and conditions")
                    }
                }
            }
            
            Button {
                
            }
            label: {
                Text(
                    authType == .login ? "Login" : "Register"
                )
            }
            .buttonStyle(AuthButtonStyle())
            
            BottomView(authType: $authType)
        }
        .padding()
        .gesture(
            TapGesture()
                .onEnded({
                    isEmailFocused = false
                    isPasswordFocused = false
                })
        )
    }
}

struct AgreeStyle: ToggleStyle{
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        }
        label: {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20)
                .contentTransition(.opacity)
        }
        .tint(.primary)
    }
}

struct AuthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(Color.white)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .background(
                LinearGradient(stops: [
                    .init(color: .red,  location: 0.0),
                    .init(color: .blue, location: 1.0)
                ], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(15)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .opacity(configuration.isPressed ? 0.05 : 1)
            .padding(.vertical, 12)
    }
}

struct BottomView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var authType: AuthType
    
    var body: some View {

        VStack(spacing: 20){
            HStack(spacing: 3){
                Text(authType == .login ? "Don't have an account?" : "Already have an account?")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                
                Button{
                    if authType == .login {
                        withAnimation{
                            authType = .register
                        }
                    } else {
                        withAnimation{
                            authType = .login
                        }
                    }
                }
                label: {
                    Text(authType == .login ? "Register" : "Login")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
            }
            
            HStack{
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundStyle(Color.gray.opacity(0.3))
                
                Text("OR")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundStyle(Color.gray.opacity(0.3))
                
            }
            
            HStack(spacing: 20){
                
                //apple button
                Button{
                    
                }
                label: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1.5)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .overlay{
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                }
                
                //google button
                Button{
                    
                }
                label: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1.5)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .overlay{
                            Image("Google")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                }
            }
        }
    }
}

struct AuthTextFieldStyle: TextFieldStyle{
    
    @Environment(\.colorScheme) private var colorScheme
    
    let isFocused: FocusState<Bool>.Binding
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isFocused.wrappedValue ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                        .zIndex(1)
                
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .light ? Color(.lightGray) : Color(uiColor: .darkGray))
                        .zIndex(0)
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused.wrappedValue)
    }
}

struct TopView: View {
    
    var body: some View {
        VStack(alignment: .center){
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            
            Text("Auth Flow")
                .font(.system(size: 35, weight: .bold, design: .rounded))
            
        }
    }
}

struct SegmentView: View {
    @Binding var authType: AuthType
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 0){
            Button {
                withAnimation{
                    authType = .login
                }
            }
            label: {
                Text("Login")
                    .fontWeight(authType == .login ? .semibold: .regular)
                    .foregroundStyle(authType == .login ? (colorScheme == .light ? Color(.darkGray) : .white) : .gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, authType == .login ? 38 : 20)
                    .background(
                        ZStack{
                            if(authType == .login){
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.3), lineWidth:0.5)
                                    .zIndex(1)
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(authType == .login ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6))
                                .zIndex(0)
                        }
                    )
            }
            
            Button {
                withAnimation{
                    authType = .register
                }
            }
            label: {
                Text("Register")
                    .fontWeight(authType == .register ? .semibold: .regular)
                    .foregroundStyle(authType == .register ? (colorScheme == .light ? Color(.darkGray) : .white) : .gray)
                    .padding(.vertical, 12)
                    .padding(.horizontal, authType == .register ? 38 : 20)
                    .background(
                        ZStack{
                            if(authType == .register){
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.3), lineWidth:0.5)
                                    .zIndex(1)
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(authType == .register ? Color(uiColor: .systemGray5) : Color(uiColor: .systemGray6))
                                .zIndex(0)
                        }
                    )
            }
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
