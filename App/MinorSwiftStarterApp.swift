import MinorUpdater
import SwiftUI

@main
struct MinorSwiftStarterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var updater = Updater()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { updater.startAutomaticChecks() }
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates…") {
                    Task { await updater.checkForUpdates() }
                }
                .disabled(!updater.isAvailable)
            }
        }

        Settings {
            SettingsView(updater: updater)
        }
    }
}
