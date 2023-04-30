/* RoundedPhoto.swift --> RouteGPT. Created by Miguel Torres on 29/04/23. */

import SwiftUI

/// Define la vista que queremos para las imágenes de cada lugar, como su tamaño, forma, ubicación en assets, etc.
struct RoundedPhoto: View {
    var body: some View {
        Image("back")
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4.0)
            }
            .shadow(radius: 7.0)
    }
}

struct RoundedPhoto_Previews: PreviewProvider {
    static var previews: some View {
        RoundedPhoto()
    }
}
