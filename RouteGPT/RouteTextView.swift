/* RouteTextView.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

// Importamos las bibliotecas necesarias para la interfaz de usuario y la programación reactiva
import SwiftUI

struct RouteTextView: View {
    
    // Declaramos la instancia de tipo SharedInfoModel para accedero a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                // Vista de perfil de usuario
                NavigationLink(destination: ProfileView().environmentObject(sharedInfo)) {
                    Image(sharedInfo.image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(50)
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
                
                Spacer()
                
                // Vista de origen
                TextField("Origen", text: $sharedInfo.textFieldOrigin) // Si cambiamos la variable por "userInput" esa se manda a chatGPT (textFieldOrigin)
                    .padding(30)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Vista de destino
                TextField("Destino", text: $sharedInfo.textFieldDestiny)
                    .padding(30)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
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
    }
}

struct RouteTextView_Previews: PreviewProvider {
    static var previews: some View {
        let sharedInfo = SharedInfoModel()
        RouteTextView().environmentObject(sharedInfo)
    }
}
