//
//  APODViewModel.swift
//  Learn IOS
//
//  Created by redveloper on 3/11/25.
//

import Foundation
import SwiftUI

@MainActor
class APODViewModel: ObservableObject {
    
    @Published var apodData: [APODModel] = []
    
    let apiKey = "GDMNwaLeyTO2WCGJKTwcAg2Ef1Fh7ZGd60pGb0OG"
    
    func fetchData(){
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&count=1")
        else {
            print("Invalid URL")
            return
        }
        
        Task{
            do{
                let(data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                if let decodeData = try? decoder.decode([APODModel].self, from: data){
                    self.apodData = decodeData
                }
            }
            catch{
                print("Error:\(error.localizedDescription)")
            }
        }
    }
}
