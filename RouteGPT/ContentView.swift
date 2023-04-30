/* ContentView.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import SwiftUI

struct ContentView: View {
    
    @StateObject private var sharedInfo = SharedInfoModel()
    
    var body: some View {
        NavigationView {
            RouteTextView()
        }
        .environmentObject(sharedInfo) // Lo agregamos a todo el NavitationView completo
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
