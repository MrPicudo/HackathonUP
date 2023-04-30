/* SharedInfoModel.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import Combine
import SwiftUI

/// Almacena todas las variables observables que necesitamos compartir entre vistas
class SharedInfoModel: ObservableObject {
    @Published var gptResponse: String = ""
    @Published var textFieldOrigin: String = ""
    @Published var textFieldDestiny: String = ""
    
    // Variables observables del perfil
    @Published var image: String = "usuario"
    @Published var name: String = ""
    @Published var age: Int?
    @Published var preferedT: String = ""
    @Published var optimize: String = ""
    
}
