import MinorLog
import os

/// App-wide loggers; one category per area.
enum AppLog {
    static let app = Log.logger("App")
}
