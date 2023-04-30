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
    
    // Preferencias de optimización
    @State private var sec = false
    @State private var quick = false
    @State private var cheap = false
    
    // Variable de estado para activar o desactivar los botones
    @State private var editing = false
    @State private var buttonTitle = "Editar"
    
    var body: some View {
        ZStack {
            Image("backnaranja")
                .resizable()
                .ignoresSafeArea(.all)
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
                        } label: {
                            Image("carro")
                                .resizable()
                        }
                        .disabled(!editing)
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            bus.toggle()
                        } label: {
                            Image("publico")
                                .resizable()
                        }
                        .disabled(!editing)
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            bic.toggle()
                        } label: {
                            Image("bicicleta")
                                .resizable()
                        }
                        .disabled(!editing)
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            walk.toggle()
                        } label: {
                            Image("caminar")
                                .resizable()
                        }
                        .disabled(!editing)
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
                    // Botones para elegir el transporte preferido
                    HStack(spacing: 35) {
                        Button {
                            sec.toggle()
                        } label: {
                            Image("seguridad")
                                .resizable()
                        }
                        .disabled(!editing)
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            quick.toggle()
                        } label: {
                            Image("velocidad")
                                .resizable()
                        }
                        .disabled(!editing)
                        .modifier(ButtonStyle(editing: editing))
                        Button {
                            cheap.toggle()
                        } label: {
                            Image("economia")
                                .resizable()
                        }
                        .disabled(!editing)
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
