/* RouteGPTApp.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import SwiftUI

@main
struct RouteGPTApp: App {
    
    @StateObject private var sharedInfo = SharedInfoModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sharedInfo)
        }
    }
}
