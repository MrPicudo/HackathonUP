/* ContentView.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                NavigationLink(destination: RouteTextView()) {
                    Text("Rutas de viaje")
                }
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Función 1")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
