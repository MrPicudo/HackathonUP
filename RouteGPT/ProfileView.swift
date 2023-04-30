import SwiftUI

struct ProfileView: View {
    
    // Declaramos la instancia de tipo SharedInfoModel para acceder a las variables de ambiente.
    @EnvironmentObject var sharedInfo: SharedInfoModel
    // Contiene nombre, edad, transporte preferido y optimización.
    
    @State private var edad = 12.0
    
    // Medio de transporte preferido, solo 1 a la vez.
    @State private var car = false
    @State private var bus = false
    @State private var walk = false
    @State private var bic = false
    
    @State private var carChoise = false
    @State private var busChoise = false
    @State private var walkChoise = false
    @State private var bicChoise = false
    
    // Preferencias de optimización
    @State private var sec = false
    @State private var quick = false
    @State private var cheap = false
    
    @State private var secChoise = false
    @State private var quickChoise = false
    @State private var cheapChoise = false
    
    // Variable de estado para activar o desactivar los botones
    @State private var editing = false
    @State private var selected01 = false
    @State private var selected02 = false
    @State private var buttonTitle = "Editar"
    
    var body: some View {
        ZStack {
            /*
            Image("backnaranja")
                .resizable()
                .ignoresSafeArea(.all)
             */
            VStack{
                // Grupo de foto de perfil, nombre y edad
                Group {
                    Image("iavoy1")
                        .resizable()
                        .frame(width: 75, height:25)
                    HStack {
                        Image(sharedInfo.image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(50)
                            .shadow(radius: 20)
                        Spacer()
                        TextField("Nombre", text: $sharedInfo.name)
                            .padding(30)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(!editing)
                            .opacity(editing ? 1.0 : 0.5)
                            .animation(.easeInOut, value: editing)
                    }
                    
                    Divider()
                    Spacer()
                    
                    Slider(
                        value: $edad,
                        in: 12...99,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("12")
                    } maximumValueLabel: {
                        Text("99")
                    }
                    .disabled(!editing)
                    
                    Text("\(edad.formatted())")
                        .foregroundColor(.blue)
                }
                
                Divider()
                Spacer()
                
                // Grupo de transporte preferido
                Group {
                    // Opciones de transporte preferido
                    Text("Transporte preferido")
                        .font(.title)
                    // Botones para elegir el transporte preferido
                    HStack {
                        Button {
                            car.toggle()
                            selected01.toggle()
                            carChoise.toggle()
                        } label: {
                            Image((!editing || (selected01 && carChoise == false)) ? "carro2" : "carro")
                                .resizable()
                        }
                        .disabled(!editing || (selected01 && carChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            bus.toggle()
                            selected01.toggle()
                            busChoise.toggle()
                        } label: {
                            Image((!editing || (selected01 && busChoise == false)) ? "publico2" : "publico")
                                .resizable()
                        }
                        .disabled(!editing || (selected01 && busChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            bic.toggle()
                            selected01.toggle()
                            bicChoise.toggle()
                        } label: {
                            Image((!editing || (selected01 && bicChoise == false)) ? "bicicleta2" : "bicicleta")
                                .resizable()
                        }
                        .disabled(!editing || (selected01 && bicChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            walk.toggle()
                            selected01.toggle()
                            walkChoise.toggle()
                        } label: {
                            Image((!editing || (selected01 && walkChoise == false)) ? "caminar2" : "caminar")
                                .resizable()
                        }
                        .disabled(!editing || (selected01 && walkChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                    }
                }
                
                Divider()
                Spacer()
                
                // Grupo de preferencias de viaje
                Group {
                    // Opciones de optimización
                    Text("Preferencias de viaje")
                        .font(.title)
                    // Botones para elegir las preferencias de viaje
                    HStack(spacing: 35) {
                        Button {
                            sec.toggle()
                            selected02.toggle()
                            secChoise.toggle()
                        } label: {
                            Image((!editing || (selected02 && secChoise == false)) ? "seguridad2" : "seguridad")
                                .resizable()
                        }
                        .disabled(!editing || (selected02 && secChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            quick.toggle()
                            selected02.toggle()
                            quickChoise.toggle()
                        } label: {
                            Image((!editing || (selected02 && quickChoise == false)) ? "velocidad2" : "velocidad")
                                .resizable()
                        }
                        .disabled(!editing || (selected02 && quickChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            cheap.toggle()
                            selected02.toggle()
                            cheapChoise.toggle()
                        } label: {
                            Image((!editing || (selected02 && cheapChoise == false)) ? "economia2" : "economia")
                                .resizable()
                        }
                        .disabled(!editing || (selected02 && cheapChoise == false))
                        .modifier(ButtonStyle(editing: editing))
                    }
                    .padding(10)
                }
                
                Divider()
                Spacer()
                
                Button {
                    editing.toggle()
                    if editing {
                        buttonTitle = "Hecho"
                    }
                    else {
                        buttonTitle = "Editar"
                    }
                } label: {
                    Text(buttonTitle)
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
            .padding(30)
        }
    }
}

struct ButtonStyle: ViewModifier {
    
    var editing: Bool

    func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80)
            .shadow(radius: 10)
            .opacity(editing ? 1.0 : 0.5)
            .animation(.easeInOut, value: editing)
    }
}

struct Perfil_Previews: PreviewProvider {
    static var previews: some View {
        let sharedInfo = SharedInfoModel()
        ProfileView().environmentObject(sharedInfo)
    }
}
