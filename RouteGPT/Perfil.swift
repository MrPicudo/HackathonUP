import SwiftUI

struct Perfil: View {
    @State private var edad = 5
    @State private var car = false
    @State private var bus = false
    @State private var walk = false
    @State private var sec = false
    @State private var quick = false
    @State private var cheap = false
    
    var body: some View {
        //CircleImage()
        VStack{
            Text("Edad")
                .font(.title)
                .padding(30)
            Stepper (
                value: $edad,
                in: 5...100,
                step: 1){
                    Text("Edad: \(edad)")
                }
            Text("Transporte")
                .font(.title2)
            Toggle( "Carro ", isOn: $car)
            Toggle("Camion", isOn: $bus)
            Toggle("Caminando", isOn: $walk)
            Text("Preferencias")
            Toggle("Seguridad", isOn: $sec)
            Toggle("Rapidez" ,isOn: $quick)
            Toggle("Económico", isOn: $cheap)
        }
        .toggleStyle(.switch)
        .padding(30)
        
    }
    
}

struct Perfil_Previews: PreviewProvider {
    static var previews: some View {
        Perfil()
    }
}
