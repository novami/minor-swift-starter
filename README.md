# MinorSwiftStarter

Template for Minor macOS apps: SwiftUI + AppKit, Swift 6 strict concurrency, macOS 26+, arm64,
Developer ID + notarization, updates from GitHub Releases via [MinorSwiftCore](https://github.com/novami/MinorSwiftCore).

## New app from the template

1. GitHub → **Use this template** → new public repository (e.g. `MinorDLNA`), clone it.
2. `scripts/rename.sh MinorDLNA cz.example.minordlna novami/MinorDLNA`
3. In `Config/App.xcconfig` set `DEVELOPMENT_TEAM` and `APP_CATEGORY`; add images to `AppIcon`.
4. Add repository secrets (see below), protect `main` (below), commit, push.

## Layout

| Path | Content |
|---|---|
| `App/` | `@main`, `AppDelegate` (AppKit bridge), assets |
| `Core/` | app-wide services (loggers, …) |
| `Features/` | one folder per feature |
| `Tests/` | XCTest, hosted in the app |
| `Config/` | all build settings (`*.xcconfig`), `Info.plist`, entitlements |

Folders are synchronized groups: files added on disk appear in Xcode without touching `project.pbxproj`.
Build settings live only in `Config/*.xcconfig`; keep the target settings in Xcode empty.

## Versioning and release

- Version = `MARKETING_VERSION` in `Config/Version.xcconfig` (`major.minor.patch`, no `v`); build number equals it.
- Add a `## X.Y.Z` section to `CHANGELOG.md`, merge to `main`, then:

  ```bash
  git tag 1.2.3 && git push origin 1.2.3
  ```

- The release workflow fails if the tag differs from `MARKETING_VERSION` or is not on `main`.
  It builds, signs with Developer ID, notarizes, staples and publishes `<App>-1.2.3.zip` as a GitHub Release,
  which the in-app updater picks up.

## Secrets

| Secret | Content |
|---|---|
| `DEVELOPER_ID_P12` | `base64 -i DeveloperID.p12` |
| `DEVELOPER_ID_P12_PASSWORD` | `.p12` password |
| `ASC_KEY_ID` | App Store Connect API key ID (Users and Access → Integrations) |
| `ASC_ISSUER_ID` | issuer ID |
| `ASC_KEY_P8` | `base64 -i AuthKey_XXXX.p8` |

Without secrets, CI (lint + tests) works; only the release job fails.

## Branch protection

A failing lint/test blocks a merge only with a ruleset on `main` requiring the checks
`lint / swiftlint` and `test / xctest` (Settings → Rules → Rulesets).

## Local development

- Debug builds are signed "to run locally" — no certificate needed; the updater is disabled in them.
- `swiftlint lint --strict` before pushing (CI uses SwiftLint 0.65.1 with `--strict`, so warnings fail too).
