/* RouteTextView.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

// Importamos las bibliotecas necesarias para la interfaz de usuario y la programación reactiva
import SwiftUI

struct RouteTextView: View {
    
    // Declaramos la instancia de tipo SharedInfoModel para accedero a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    
    @ObservedObject var speechManager: SpeechManager
    
    // Instancia y variables para el reconocimiento de voz
    // @StateObject private var speechManager = SpeechManager()
    @State private var originButtonTitle = "Origen"
    @State private var destinyButtonTitle = "Destino"
    
    var body: some View {
        ZStack {
            Image("b")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                // Vista de perfil de usuario
                NavigationLink(destination: ProfileView().environmentObject(sharedInfo)) {
                    Image(sharedInfo.image)
                        .resizable()
                        .frame(width: 130, height: 130)
                        .cornerRadius(50)
                        .shadow(radius: 30)
                }.padding(20)
                
                HStack {
                    Text("¡Hola " + sharedInfo.name + "!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.bottom, 5)
                
                
                HStack {
                    Text("¿A dónde vamos a ir hoy?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }.padding(.leading, 30)
                
                Divider()
                
                // Botón de origen, con reconocimiento de voz
                Button{
                    speechManager.recordButtonTapped()
                    // Comprobamos si el motor de audio está en funcionamiento.
                    if speechManager.audioEngine.isRunning {
                        // Si está funcionando, actualizamos el título del botón y el estado de la grabación.
                        originButtonTitle = "Grabando..."
                    } else {
                        // Si no está funcionando, actualizamos el título del botón y el estado de la grabación.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            originButtonTitle = speechManager.recognizedVoiceText
                            sharedInfo.textFieldOrigin = originButtonTitle
                        }
                    }
                } label: {
                    HStack(spacing: 40) {
                        Image("origen")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(originButtonTitle)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width: 350)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 30)
                
                // Botón de destino, con reconocimiento de voz.
                Button{
                    speechManager.recordButtonTapped()
                    // Comprobamos si el motor de audio está en funcionamiento.
                    if speechManager.audioEngine.isRunning {
                        // Si está funcionando, actualizamos el título del botón y el estado de la grabación.
                        destinyButtonTitle = "Grabando..."
                    } else {
                        // Si no está funcionando, actualizamos el título del botón y el estado de la grabación.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            destinyButtonTitle = speechManager.recognizedVoiceText
                            sharedInfo.textFieldDestiny = destinyButtonTitle
                        }
                    }
                } label: {
                    HStack(spacing: 40) {
                        Text(destinyButtonTitle)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Image("destino")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    .frame(width: 350)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                }
  
                Spacer()
                
                NavigationLink(destination: DirectionsView().environmentObject(sharedInfo)) {
                    Text("Enviar")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
            }
        }
        .onAppear {
            speechManager.requestAuthorization()
        }
        .onDisappear {
            originButtonTitle = "Origen"
            destinyButtonTitle = "Destino"
        }
    }
}

struct RouteTextView_Previews: PreviewProvider {
    static var previews: some View {
        let sharedInfo = SharedInfoModel()
        RouteTextView(speechManager: SpeechManager()).environmentObject(sharedInfo)
    }
}
