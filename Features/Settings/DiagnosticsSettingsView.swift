import MinorLog
import SwiftUI
import UniformTypeIdentifiers

struct DiagnosticsSettingsView: View {
    @State private var error: String?

    var body: some View {
        Form {
            Text("Exports the last hour of this app's logs together with app and macOS version.")
                .foregroundStyle(.secondary)
            Button("Export Diagnostics…", action: export)
            if let error {
                Text(error).foregroundStyle(.red)
            }
        }
    }

    private func export() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "\(Log.subsystem)-diagnostics.txt"
        panel.allowedContentTypes = [.plainText]
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try Diagnostics.export(to: url)
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
}
