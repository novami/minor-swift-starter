@testable import MinorSwiftStarter
import MinorUpdater
import XCTest

@MainActor
final class MinorSwiftStarterTests: XCTestCase {
    func testMarketingVersionIsSemantic() {
        let raw = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        XCTAssertNotNil(SemanticVersion(raw), "MARKETING_VERSION must be major.minor.patch, got '\(raw)'")
    }

    func testUpdateRepositoryIsConfigured() {
        let repository = Bundle.main.object(forInfoDictionaryKey: Updater.infoKey) as? String ?? ""
        XCTAssertEqual(repository.split(separator: "/").count, 2, "Set UPDATE_REPOSITORY in Config/App.xcconfig")
    }
}
