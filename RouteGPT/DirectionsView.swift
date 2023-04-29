//
//  MapView.swift
//  RouteGPT
//
//  Created by iOS Lab on 29/04/23.
//
import SwiftUI
import MapKit

struct DirectionsView: View {
    @State private var instrucciones: [String] = []
    @State private var showDirections = false
    
    var body: some View {
        VStack{
            MapView(instrucciones: $instrucciones)
            Button(action: {
                self.showDirections.toggle()
            }, label: {
                Text("Show directions")
            })
            .disabled(instrucciones.isEmpty)
            .padding()
        }.sheet(isPresented: $showDirections, content: {VStack(spacing:0) {
            Text("Directions")
                .font(.largeTitle)
                .bold()
                .padding()
            Divider().background(Color.blue)
            List{
                ForEach( 0..<self.instrucciones.count, id: \.self) {
                    i in Text(self.instrucciones[i])
                        .padding()
                }
            }
        }})
    }
}

struct MapView : UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var instrucciones: [String]
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        //CDMX
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.03793, longitude: -98.20346))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .walking;
        
        let directions = MKDirections(request: request)
        directions.calculate{
            response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            for r in response!.routes {
                                for step in r.steps {
                                    instrucciones.append(step.instructions)
                                }
                            }
        }
        return mapView
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView,  rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}
