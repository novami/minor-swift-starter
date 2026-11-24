import MinorUpdater
import SwiftUI

struct SettingsView: View {
    let updater: Updater

    var body: some View {
        TabView {
            Tab("Updates", systemImage: "arrow.triangle.2.circlepath") {
                UpdateSettingsView(updater: updater)
            }
            Tab("Diagnostics", systemImage: "stethoscope") {
                DiagnosticsSettingsView()
            }
        }
        .frame(width: 460)
        .scenePadding()
    }
}
