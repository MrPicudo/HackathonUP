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
    // Declaramos la instancia de tipo SharedInfoModel para acceder a las variables de ambiente.
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
            if sharedInfo.indicaciones != "" {
                MapView(instrucciones: $instrucciones)
            }
            else {
                Image("iavoy2")
                    .resizable()
                    .scaledToFit()
            }
            
            // Scroll view para la información retornada de la API
            ScrollView {
                Text(sharedInfo.indicaciones)
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
            sharedInfo.indicaciones = ""
            sharedInfo.textFieldOrigin = ""
            sharedInfo.textFieldDestiny = ""
            sharedInfo.latOri = 0.0
            sharedInfo.lonOri = 0.0
            sharedInfo.latDes = 0.0
            sharedInfo.latDes = 0.0
        }
        
    }
    
    // Definimos una función privada para enviar una solicitud a la API de GPT
    private func sendGPTRequest() {
        // Cancelamos cualquier solicitud anterior que pueda estar en curso
        cancellable?.cancel()
        // Creamos un prompt modificado que incluye la entrada del usuario
        let modifiedUserInput = """
Eres un experto en los diferentes medios de transporte y conoces muy bien las rutas más adecuadas para cada tipo de transporte en México, ya sea en auto, transporte público, bicicleta o caminando. Te voy a mandar el nombre de dos sitios, uno es el sitio de origen y el otro es el sitio de destino de un viaje que necesito realizar. Necesito que escribas los valores de las coordenadas de latitud y longitud de cada sitio, en líneas separadas, siguiendo estrictamente el siguiente formato:
Latitud de sitio de origen: (valor de latitud de origen con decimales)
Longitud de sitio de origen: (valor de longitud de origen con decimales)
Latitud de sitio de destino: (valor de latitud de destino con decimales)
Longitud de sitio de destino: (valor de longitud de destino con decimales)
Importante, NO dejes renglones en blanco.
Posteriormente, dame las indicaciones detalladas para llegar del origen al destino utilizando la mejor ruta posible. Considera que soy una persona de 29 años cuyo medio de transporte preferido es el transporte público y mi objetivo es ir en la ruta más económica posible. Dame un aproximado de tiempo y costo para la ruta, distancia aproximada y si hay algo específico a considerar, menciónalo en una nota aparte.
Origen: \(sharedInfo.textFieldOrigin)
Destino: \(sharedInfo.textFieldDestiny)
"""
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
                print(response)
                // Manejo de la cadena obtenida de la API
                let lines = sharedInfo.gptResponse.components(separatedBy: .newlines)

                if lines.count >= 3 {
                    /*
                    let line1 = lines[0]
                    sharedInfo.latOri = Double(line1) ?? 19.25465
                    let line2 = lines[1]
                    sharedInfo.lonOri = Double(line2) ?? -99.10356
                    let line3 = lines[2]
                    sharedInfo.latDes = Double(line3) ?? 19.3467
                    let line4 = lines[3]
                    sharedInfo.lonDes = Double(line4) ?? -99.16174
                     */
                    // Obtenemos el resto del texto
                    let remainingLines = lines[4...].joined(separator: "\n")
                    sharedInfo.indicaciones = remainingLines
                    
                    var extractedValues: [String] = []

                    for line in lines {
                        if let range = line.range(of: ": ") {
                            let value = line[range.upperBound...].trimmingCharacters(in: .whitespaces)
                            extractedValues.append(value)
                        }
                    }
                    sharedInfo.latOri = Double(extractedValues[0])
                    sharedInfo.lonOri = Double(extractedValues[1])
                    sharedInfo.latDes = Double(extractedValues[2])
                    sharedInfo.lonDes = Double(extractedValues[3])
                    print(extractedValues)
                    
                    
                } else {
                    print("El texto analizado tiene menos de 4 líneas.")
                }
            })
    }
}

/// MapView representa un mapa y permite mostrar direcciones entre dos puntos
struct MapView : UIViewRepresentable {
    
    // Declaramos la instancia de tipo SharedInfoModel para acceder a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    
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
        // Crean dos sitios (origen y destino) con sus coordenadas
        let startingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sharedInfo.latOri ?? 10, longitude: sharedInfo.lonOri ?? -90))
        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sharedInfo.latDes ?? 10.5, longitude: sharedInfo.lonDes ?? -90.5))
        // Crear un objeto MKMapView
        let mapView = MKMapView()
        // Asignar el delegado del mapa al coordinador
        mapView.delegate = context.coordinator
        // Configurar la región del mapa
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: sharedInfo.latOri ?? 10, longitude: sharedInfo.lonOri ?? -90), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        // Crear dos puntos en el mapa (p1 y p2)
        let p1 = MKPointAnnotation()
        // Se asignan las mismas coordenas que en placemark
        p1.coordinate = startingPlacemark.coordinate
        // Cambia el valor de la etiqueta
        p1.title = "Origen"
        let p2 = MKPointAnnotation()
        p2.coordinate = destinationPlacemark.coordinate
        p2.title = "Destino"
        // Añaden los dos puntos a el mapa
        mapView.addAnnotations([p1, p2])
        
        // Crear y configurar una solicitud de direcciones
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
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
        let sharedInfo = SharedInfoModel()
        DirectionsView().environmentObject(sharedInfo)
    }
}
