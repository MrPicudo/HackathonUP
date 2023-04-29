/* RouteTextView.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

// Importamos las bibliotecas necesarias para la interfaz de usuario y la programación reactiva
import SwiftUI
import Combine

struct RouteTextView: View {
    
    // Variable de estado que almacena el texto de los text fields
    @State private var textFieldOrigin = ""
    @State private var textFieldDestiny = ""
    @State private var conveyance = ""
    
    // Declaramos las propiedades de estado para almacenar la entrada del usuario, la respuesta de GPT y el objeto cancelable
    @State private var userInput = ""
    @State private var gptResponse = ""
    @State private var cancellable: AnyCancellable?
    
    // Creamos una instancia de GPTAPIManager para manejar las solicitudes a la API
    private let gptAPIManager = GPTAPIManager()
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                // Vista de perfil de usuario
                HStack {
                    Spacer()
                    Button {
                        print("Imagen de perfil")
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                            .padding(20)
                    }
                }
                Spacer()
                // Vista de origen
                TextField("Origen", text: $textFieldOrigin) // Si cambiamos la variable por "userInput" esa se manda a chatGPT (textFieldOrigin)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Vista de destino
                TextField("Destino", text: $textFieldDestiny)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
                
                
                
                // Llamamos a la función sendGPTRequest cuando se presiona el link que nos manda a la siguiente vista
                NavigationLink(destination: { () -> DirectionsView in   // Closure para la función destination
                    sendGPTRequest()
                    return DirectionsView()
                }() ) { // Establecemos el estilo y la apariencia del link
                    Text("Enviar")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                 
                
                ScrollView {
                    // Mostramos la respuesta de GPT en un cuadro de texto
                    Text(gptResponse)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // Definimos una función privada para enviar una solicitud a la API de GPT
    private func sendGPTRequest() {
        // Cancelamos cualquier solicitud anterior que pueda estar en curso
        cancellable?.cancel()
        
        // Creamos un prompt modificado que incluye la entrada del usuario
        let modifiedUserInput = "¿Cómo llego de " + textFieldOrigin + " a " + textFieldDestiny + "?. Dame un aproximado de tiempo y costo para cada ruta, distancia aproximada y si hay algo específico a considerar, menciónalo en una nota aparte."
        
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
                // Actualizamos la propiedad gptResponse con la respuesta recibida de la API
                gptResponse = response
                print("Respuesta GPT: \(response)")
            })
    }
    
}

struct RouteTextView_Previews: PreviewProvider {
    static var previews: some View {
        RouteTextView()
    }
}
