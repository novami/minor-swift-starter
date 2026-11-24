import MinorUpdater
import SwiftUI

struct UpdateSettingsView: View {
    @Bindable var updater: Updater

    var body: some View {
        Form {
            Toggle("Check for updates automatically", isOn: $updater.automaticChecks)
                .disabled(!updater.isAvailable)

            LabeledContent("Status") {
                Text(statusText).foregroundStyle(.secondary)
            }

            HStack {
                Button("Check Now") { Task { await updater.checkForUpdates() } }
                    .disabled(!updater.isAvailable || updater.state == .checking)
                if case .available = updater.state {
                    Button("Install and Relaunch") { Task { await updater.installUpdate() } }
                        .buttonStyle(.borderedProminent)
                }
            }

            if case .available(_, let notes?) = updater.state {
                Text(notes).font(.callout).textSelection(.enabled)
            }
        }
    }

    private var statusText: String {
        switch updater.state {
        case .unavailable(let reason): reason
        case .idle: "Not checked yet"
        case .checking: "Checking…"
        case .upToDate: "Up to date"
        case .available(let version, _): "Version \(version) is available"
        case .downloading: "Downloading…"
        case .failed(let message): message
        }
    }
}
