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
                        .padding()
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
            }
        }
    }
}

struct RouteTextView_Previews: PreviewProvider {
    static var previews: some View {
        RouteTextView()
    }
}
