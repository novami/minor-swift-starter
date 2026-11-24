import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentUnavailableView("MinorSwiftStarter", systemImage: "shippingbox", description: Text("Replace this view."))
            .frame(minWidth: 480, minHeight: 320)
    }
}

#Preview {
    ContentView()
}
