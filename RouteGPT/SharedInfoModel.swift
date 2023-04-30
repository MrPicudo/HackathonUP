/* SharedInfoModel.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import Combine
import SwiftUI

/// Almacena todas las variables observables que necesitamos compartir entre vistas
class SharedInfoModel: ObservableObject {
    // Variables para el paso de información a la API
    @Published var gptResponse: String = ""
    @Published var textFieldOrigin: String = ""
    @Published var textFieldDestiny: String = ""
    
    // Variables observables del perfil
    @Published var image: String = "usuario"
    @Published var name: String = "Ari Barrera"
    @Published var age: Int?
    @Published var preferedT: String = ""
    @Published var optimize: String = ""
    
    // Variables de coordenadas
    @Published var latOri: Double?
    @Published var lonOri: Double?
    @Published var latDes: Double?
    @Published var lonDes: Double?
    
    // Variable de indicaciones
    @Published var indicaciones: String = ""
}
