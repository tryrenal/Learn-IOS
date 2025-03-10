//
//  ContentView.swift
//  Learn IOS
//
//  Created by redveloper on 3/8/25.
//

import SwiftUI

enum OnboardingPage: Int, CaseIterable{
    case browserMenu
    case quickDelivery
    case orderTracking
    
    var title: String{
        switch self {
        case .browserMenu:
            return "Browser Menus"
        case .quickDelivery:
            return "Lightning Fast Delivery"
        case .orderTracking:
            return "Real-Time Tracking"
        }
    }
    
    var description: String {
        switch self {
        case .browserMenu:
            return "Discover a world of flavors from top-rated restaurants, all at your fingerprints."
        case .quickDelivery:
            return "From kitchen to your doorstep in minutes, always fresh and delicious!"
        case .orderTracking:
            return "Watch your order's journey in real-time, from preparation to delivery."
        }
    }
}

struct ContentView: View {
    @State private var currentPage = 0
    @State private var isAnimation = false
    @State private var deliveryOffset = false
    @State private var trackingProgress = false
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage){
                ForEach(OnboardingPage.allCases, id: \.rawValue){ page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            
            HStack(spacing: 12){
                ForEach(0..<OnboardingPage.allCases.count, id: \.self){ index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 :8, height: currentPage == index ? 12 : 8)
                        .animation(.spring(), value: currentPage)
                }
            }
            
            Button {
                withAnimation(.spring()){
                    if currentPage < OnboardingPage.allCases.count - 1 {
                        currentPage += 1
                        
                        isAnimation = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            isAnimation = true
                        })
                    } else {
                        
                    }
                }
            }
            label: {
                Text(currentPage < OnboardingPage.allCases.count - 1 ? "Next" : "Get Started")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [
                            Color.blue,
                            Color.blue.opacity(0.8)
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.blue.opacity(0.3),radius: 10, x:0, y:5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:{
                withAnimation{
                    isAnimation = true
                }
            })
        }
    }
    
    private var foodImagesGroup: some View {
        ZStack{
            Image("coffee")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .offset(x: -120, y: isAnimation ? 0:40)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimation)
            
            Image("fries")
                .resizable()
                .scaledToFit()
                .frame(height: 240)
                .offset(x: 120, y: isAnimation ? 0:40)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimation)
            
            Image("burger")
                .resizable()
                .scaledToFit()
                .frame(height: 210)
                .offset(y: isAnimation ? 0:10)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimation)
            
        }
    }
    
    private var deliveryAnimation: some View {
        ZStack{
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimation ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(),value: isAnimation)
            
            Image("truck")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .frame(width: 330)
                .offset(y: deliveryOffset ? -20 : 0)
                .rotationEffect(.degrees(deliveryOffset ? 5 : -5))
                .opacity(isAnimation ? 1 : 0)
                .animation(.spring(dampingFraction: 0.7), value: isAnimation)
        
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: 120 * cos(Double(index) * .pi / 4),
                        y: 120 * sin(Double(index) * .pi / 4)
                    )
                    .scaleEffect(isAnimation ? 1:0)
                    .opacity(isAnimation ? 0.7 : 0)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: isAnimation
                    )
            }
        }
    }
    
    private var orderTracking: some View {
        ZStack{
            Circle()
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .frame(width: 250, height: 250)
                .scaleEffect(isAnimation ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(),value: isAnimation)
            
            Image("cart")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .opacity(isAnimation ? 1:0)
                .scaleEffect(isAnimation ? 1:0)
                .rotation3DEffect(.degrees(isAnimation ? 360 : 1), axis: (x: 0, y: 1, z: 0))
                .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimation)
            
            ForEach(0..<4){ index in
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.blue)
                    .offset(
                        x: 100 * cos(Double(index) * .pi / 2),
                        y: 100 * sin(Double(index) * .pi / 2)
                    )
                    .opacity(isAnimation ? 1:0)
                    .scaleEffect(isAnimation ? 1:0)
                    .animation(.spring(dampingFraction: 0.6).delay(Double(index) * 0.1), value: isAnimation)
            }
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30){
            ZStack{
                switch page{
                case .browserMenu:
                    foodImagesGroup
                case .quickDelivery:
                    deliveryAnimation
                case .orderTracking:
                    orderTracking
                }
            }
            
            VStack(spacing: 20){
                Text(page.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimation ? 1:0)
                    .offset(y: isAnimation ? 0:20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimation)
                
                Text(page.description)
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(isAnimation ? 1:0)
                    .offset(y: isAnimation ? 0:20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimation)
            }
        }
    }
}

#Preview {
    ContentView()
}
