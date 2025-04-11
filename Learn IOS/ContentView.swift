//
//  ContentView.swift
//  Learn IOS
//
//  Created by redveloper on 3/8/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    let cameraPosition: MapCameraPosition = .region(.init(center: .init(latitude: 37.3346, longitude: -122.0090), latitudinalMeters: 1300, longitudinalMeters: 1300))
    
    let locationManger = CLLocationManager()
    
    @State private var lookArroundScene: MKLookAroundScene?
    @State private var isShowingLookArround = false
    @State private var route: MKRoute?
    
    var body: some View {
        Map(initialPosition: cameraPosition){
//            Marker("Apple Visitor Center", systemImage: "laptopcomputer", coordinate: .appleVisitorCenter)
//            Marker("Panama Park", systemImage: "tree.fill", coordinate: .panamaPark)
//                .tint(.green)
            
            Annotation("Apple Visitor Center", coordinate: .appleVisitorCenter, anchor: .bottom){
                Image(systemName: "laptopcomputer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .padding(7)
                    .background(.pink.gradient, in: .circle)
                    .contextMenu{
                        Button("open look arround", systemImage: "binoculars"){
                            Task {
                                lookArroundScene = await getLookArroundScene(from: .appleVisitorCenter)
                                guard lookArroundScene != nil else { return }
                                isShowingLookArround = true
                            }
                        }
                        Button("Get Directions", systemImage: "arrow.turn.down.right"){
                            getDirections(to: .appleVisitorCenter)
                        }
                    }
            }
            
            Annotation("Panama Park", coordinate: .panamaPark, anchor: .bottom){
                Image(systemName: "tree.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .padding(7)
                    .background(.green.gradient, in: .circle)
                    .contextMenu{
                        Button("open look arround", systemImage: "binoculars"){
                            Task {
                                lookArroundScene = await getLookArroundScene(from: .panamaPark)
                                guard lookArroundScene != nil else { return }
                                isShowingLookArround = true
                            }
                        }
                        Button("Get Directions", systemImage: "arrow.turn.down.right"){
                            getDirections(to: .panamaPark)
                        }
                    }
            }
            
            UserAnnotation()
            
            if let route {
                MapPolyline(route)
                    .stroke(Color.pink, lineWidth: 4)
            }
            
            
        }
        .tint(.pink)
        .onAppear{
            locationManger.requestWhenInUseAuthorization()
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .lookAroundViewer(isPresented: $isShowingLookArround, initialScene: lookArroundScene)
    }
    
    func getLookArroundScene(from coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        do {
            return try await MKLookAroundSceneRequest(coordinate: coordinate).scene
        }
        catch{
            print("Cant retrive look arround scene: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            let update = try await updates.first {
                $0.location?.coordinate != nil
            }
            return update?.location?.coordinate
        }
        catch {
            print("cant get user location")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D){
        Task {
            guard let userLocation = await getUserLocation() else {return}
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .walking
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
            }
            catch {
                print("cant get route")
            }
        }
    }
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D{
    static let appleHQ = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
    static let appleVisitorCenter = CLLocationCoordinate2D(latitude: 37.332753, longitude: -122.005372)
    static let panamaPark = CLLocationCoordinate2D(latitude: 37.347730, longitude: -122.018715)
}
