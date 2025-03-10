//
//  ContentView.swift
//  Learn IOS
//
//  Created by redveloper on 3/8/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = APODViewModel()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .center){
                ForEach(viewModel.apodData, id: \.self){ item in
                    APODDetailsView(item: item)
                }
            }
            .onAppear{
                viewModel.fetchData()
            }
        }
    }
}

struct APODDetailsView: View {
    
    let item: APODModel
    
    var body: some View {
        VStack{
            Text(item.title)
                .font(.title)
                .bold()
                .padding(.top, 40)
                .multilineTextAlignment(.center)
            
            AsyncImage(url: URL(string: item.url)!){ image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(10)
            } placeholder: {
                Color.gray
                    .frame(height: 300)
                    .padding(10)
            }
            
            Text(item.explanation)
                .lineSpacing(5)
                .font(.callout)
                .padding(10)
            
            Text("Copyright: \(item.copyright)")
                .foregroundStyle(.secondary)
            
            Text("Caption date: \(item.date)")
                .foregroundStyle(.secondary.opacity(0.8))
        }
    }
}

#Preview {
    ContentView()
}
