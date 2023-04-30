import SwiftUI

struct Perfil: View {
    
    // Declaramos la instancia de tipo SharedInfoModel para accedero a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    // Contiene nombre, edad, transporte preferido y optimización.
    
    @State private var edad = 5
    // Medio de transporte preferido, solo 1 a la vez.
    @State private var car = false
    @State private var bus = false
    @State private var walk = false
    @State private var bic = false
    // Preferencias de optimización
    @State private var sec = false
    @State private var quick = false
    @State private var cheap = false
    
    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .ignoresSafeArea(.all)
            VStack{
                HStack {
                    Image(sharedInfo.image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(50)
                    Spacer()
                    TextField("Nombre", text: $sharedInfo.name)
                        .padding(30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Divider()
                Spacer()
                
                Stepper (
                    value: $edad,
                    in: 5...100,
                    step: 1){
                        Text("Edad: \(edad)")
                            .font(.title)
                            .fontWeight(.heavy)
                    }
                
                Divider()
                Spacer()
                
                // Opciones de transporte preferido
                Text("Transporte preferido")
                    .font(.title2)
                // Botones para elegir el transporte preferido
                HStack {
                    Spacer()
                    Button {
                        car.toggle()
                    } label: {
                        Image("carro")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                    Button {
                        bus.toggle()
                    } label: {
                        Image("publico")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                    Button {
                        bic.toggle()
                    } label: {
                        Image("bicicleta")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                    Button {
                        walk.toggle()
                    } label: {
                        Image("caminar")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                }
                
                // Opciones de optimización
                Text("Preferencias de viaje")
                    .font(.title2)
                // Botones para elegir el transporte preferido
                HStack {
                    Button {
                        sec.toggle()
                    } label: {
                        Image("seguridad")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Button {
                        quick.toggle()
                    } label: {
                        Image("velocidad")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Button {
                        cheap.toggle()
                    } label: {
                        Image("economia")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(10)
            }
            .toggleStyle(.switch)
            .padding(30)
        }
        
    }
}

struct Perfil_Previews: PreviewProvider {
    static var previews: some View {
        let sharedInfo = SharedInfoModel()
        Perfil().environmentObject(sharedInfo)
    }
}
