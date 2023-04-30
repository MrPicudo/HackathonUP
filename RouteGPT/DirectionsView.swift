/* MapView.swift --> RouteGPT. Created by iOS Lab on 29/04/23. */

// Importamos los módulos necesarios
import SwiftUI
import MapKit
import Combine

/// Vista que muestra un mapa y permite mostrar direcciones entre dos puntos
struct DirectionsView: View {
    
    // Lista de instrucciones de dirección
    @State private var instrucciones: [String] = []
    // Controla si se muestran las instrucciones de dirección en una hoja
    @State private var showDirections = false
    // Declaramos la instancia de tipo SharedInfoModel para accedero a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    // Creamos una instancia de GPTAPIManager para manejar las solicitudes a la API
    private let gptAPIManager = GPTAPIManager()
    // Declaramos las propiedades de estado para almacenar la entrada del usuario, la respuesta de GPT y el objeto cancelable
    @State private var userInput = ""
    @State private var cancellable: AnyCancellable? // Viene del framework Combine
    
    // Definimos la estructura de la vista
    var body: some View {
        // VStack organiza verticalmente las vistas dentro
        VStack{
            // MapView representa la vista del mapa y recibe las instrucciones
            MapView(instrucciones: $instrucciones)
            // Scroll view para la información retornada de la API
            ScrollView {
                Text(sharedInfo.gptResponse)
            }
            .padding()
            
            // Botón que muestra las instrucciones de dirección
            Button {
                // Cambia el estado de showDirections
                self.showDirections.toggle()
            } label: {
                // Texto que se muestra en el botón
                Text("Show directions")
            }
            .disabled(instrucciones.isEmpty) // Deshabilita el botón si no hay instrucciones
            .padding() // Espaciado alrededor del botón
        }
        // Presenta la hoja con las instrucciones si showDirections es verdadero
        .sheet(isPresented: $showDirections, content: {VStack(spacing:0) {
            // Título de las instrucciones
            Text("Directions")
                .font(.largeTitle)
                .bold()
                .padding()
            // Divider separa visualmente el título y la lista de instrucciones
            Divider().background(Color.blue)
            // Lista que muestra las instrucciones de dirección
            List{
                // Itera sobre las instrucciones y muestra cada una en un Text
                ForEach( 0..<self.instrucciones.count, id: \.self) {
                    i in Text(self.instrucciones[i])
                    // Espaciado alrededor de cada instrucción
                        .padding()
                }
            }
        }})
        .onAppear {
            sendGPTRequest()
        }
        .onDisappear {
            sharedInfo.gptResponse = ""
        }
        
    }
    
    // Definimos una función privada para enviar una solicitud a la API de GPT
    private func sendGPTRequest() {
        // Cancelamos cualquier solicitud anterior que pueda estar en curso
        cancellable?.cancel()
        // Creamos un prompt modificado que incluye la entrada del usuario
        let modifiedUserInput = "¿Cómo llego de " + sharedInfo.textFieldOrigin + " a " + sharedInfo.textFieldDestiny + "?. Dame un aproximado de tiempo y costo para cada ruta, distancia aproximada y si hay algo específico a considerar, menciónalo en una nota aparte."
        // Enviamos una solicitud a la API de GPT y manejamos el resultado usando Combine
        cancellable = gptAPIManager.sendRequest(prompt: modifiedUserInput)
            .sink(receiveCompletion: { completion in
                // Manejamos los casos de éxito y fracaso en la recepción de la respuesta
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                // Actualizamos la propiedad gptResponse en sharedInfo con la respuesta recibida de la API
                sharedInfo.gptResponse = response
                print("Respuesta GPT: \(response)")
            })
    }
}

/// MapView representa un mapa y permite mostrar direcciones entre dos puntos
struct MapView : UIViewRepresentable {
    // Tipo de vista asociada a UIViewRepresentable
    typealias UIViewType = MKMapView
    // Variable de enlace para las instrucciones de dirección
    @Binding var instrucciones: [String]
    
    // Creación del coordinador para MapView
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    // Creación de la vista MKMapView
    func makeUIView(context: Context) -> MKMapView{
        // Crear un objeto MKMapView
        let mapView = MKMapView()
        // Asignar el delegado del mapa al coordinador
        mapView.delegate = context.coordinator
        // Configurar la región del mapa
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        // Crear dos puntos en el mapa (p1 y p2)
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.03793, longitude: -98.20346))
        // Crear y configurar una solicitud de direcciones
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .walking;
        
        // Crear objeto de direcciones y calcular la ruta
        let directions = MKDirections(request: request)
        directions.calculate{
            response, error in
            // Comprobar si hay una ruta disponible
            guard let route = response?.routes.first else { return }
            // Añadir puntos al mapa
            mapView.addAnnotations([p1, p2])
            // Añadir la ruta al mapa como una línea
            mapView.addOverlay(route.polyline)
            // Ajustar el mapa para mostrar la ruta completa
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            // Iterar sobre las rutas y sus pasos para guardar las instrucciones
            for r in response!.routes {
                for step in r.steps {
                    instrucciones.append(step.instructions)
                }
            }
        }
        // Devolver la vista del mapa creada
        return mapView
    }
    
    // Función para actualizar la vista del mapa, en este caso vacía
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    /// Actúa como delegado para el mapa y maneja la representación de las rutas
    class MapViewCoordinator: NSObject, MKMapViewDelegate{
        // Función para configurar la apariencia de la ruta en el mapa
        func mapView(_ mapView: MKMapView,  rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            // Crear un objeto MKPolylineRenderer para personalizar la ruta
            let renderer = MKPolylineRenderer(overlay: overlay)
            // Establecer el color y el ancho de la línea de la ruta
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            // Devolver el renderizador configurado
            return renderer
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}
