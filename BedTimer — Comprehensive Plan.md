BedTimer — Comprehensive Plan (Cursor Version)

1. Product Vision

BedTimer is a minimalist alarm companion app designed to reduce lingering in bed after waking. The system combines iPhone alarms, Apple Watch quick interactions, widgets/complications, and cloud-synced history tracking.

⸻

2. Core Features

Alarm & Notifications
	•	Local iOS alarms with notification actions: Start Countdown, Snooze, Out of Bed.
	•	Live Activity (Dynamic Island/Lock Screen) showing countdown progress.

Bed Session Tracking
	•	Start → Acknowledged time
	•	End → Out of bed time
	•	Goal duration vs. Actual lingering time
	•	Record deletion (single session or bulk)

Apple Watch Support
	•	Watch app with large Start/Out/Snooze buttons
	•	Haptics for feedback
	•	Complications (corner, circular, inline) for countdown
	•	Siri Shortcuts: “Start BedTimer”, “Stop BedTimer”, “Delete last record”

Widgets (iOS)
	•	Small: Remaining countdown
	•	Medium: Weekly averages
	•	Large: History streaks, quick actions

⸻

3. Monetization Model

Free (Ad-Supported)
	•	All features available
	•	Ads shown in iPhone app (history screen)
	•	Local-only storage

Free+ (Ad-Free + iCloud)
	•	Ads removed
	•	iCloud/CloudKit sync across devices
	•	Multi-device history and widgets with real-time sync

(Optional future tier) Pro ($1.99/month)
	•	Advanced statistics & trends
	•	HealthKit integration
	•	Gamification (badges, streak challenges)
	•	Export (CSV/Health app)

⸻

4. UX Flows
	•	Wake Flow: Alarm → Tap “I’m up” → Countdown → Out of bed → Record stored
	•	Delete Flow: History → Swipe or tap delete → Confirm → Update stats
	•	Widget Flow: Home/Lock screen glance → Remaining countdown or latest streak
	•	Watch Flow: One-tap start/end, haptic confirmations, complication glance

⸻

5. Data Model

BedSession
	•	id: UUID
	•	scheduledAlarm: Date
	•	goalMinutes: Int
	•	acknowledgedAt: Date?
	•	outOfBedAt: Date?
	•	derived: actualMinutes, metGoal

⸻

6. Sync & Storage
	•	MVP: SwiftData + WatchConnectivity (message + transferUserInfo)
	•	Later: CloudKit (automatic sync, conflict resolution)
	•	Deletion Policy: soft delete → permanent delete

⸻

7. Development Stack
	•	Language: Swift 5+
	•	Frameworks: SwiftUI, SwiftData, WidgetKit, ClockKit, ActivityKit
	•	Notifications: UNUserNotificationCenter
	•	Sync: WatchConnectivity, CloudKit (v2)
	•	CI/CD: GitHub Actions → TestFlight
	•	Testing: XCTest, snapshot tests

⸻

8. Development Rulebook

Principles
	•	English-first UI and code
	•	Privacy by default, user-controlled deletion
	•	UX consistency across iPhone/Watch/Widgets

Methodology
	•	Agile Scrum (2-week sprints)
	•	Feature flags for experimental functions
	•	TDD for core logic (timers, records)
	•	Accessibility checks (VoiceOver, haptics, dynamic type)
	•	Mandatory peer review for all merges

Definition of Done (DoD)
	•	Unit/UI tests pass
	•	English + Korean localization
	•	Verified on-device performance
	•	Design spec compliance

⸻

9. Success Metrics
	•	Start conversion: % of alarms that trigger “I’m up”
	•	End conversion: % of sessions that record “Out of bed”
	•	Goal success rate: % sessions meeting goal
	•	Avg. linger reduction after 4 weeks
	•	Widget/complication engagement (views, taps)

⸻

10. Risks & Mitigations
	•	Notification reliability → onboarding guidance, test-alarm feature
	•	Background execution limits → date-based calculation instead of continuous timers
	•	Sync conflicts → prioritize confirmed outOfBedAt

⸻

11. Roadmap
	•	MVP: iPhone alarm app + Watch app + local storage + widgets + ads
	•	v1.1: CloudKit sync, Siri intents, record deletion
	•	v1.2: Advanced widgets, HealthKit, Pro plan
	•	v2.0: Gamification, export, multi-language expansion

⸻

12. Project Structure & Xcode Workspace

Targets
	•	BedTimer (iOS App)
	•	BedTimerWatch (watchOS App)
	•	BedTimerWidgets (WidgetKit for iOS + watchOS complications provider where supported)
	•	BedTimerIntents (Siri Intents/Shortcuts)
	•	BedTimerKit (Swift Package: models, services, design system)
	•	BedTimerAds (Swift Package: ad surfaces; compiled only for Free tier)

Workspace Layout

BedTimer.xcworkspace
├─ Apps/
│  ├─ BedTimer/ (iOS)
│  └─ BedTimerWatch/ (watchOS)
├─ Features/
│  ├─ Sessions/ (history, delete, stats)
│  ├─ Alarm/ (notifications, live activity)
│  ├─ Widgets/
│  └─ Settings/
├─ Packages/
│  ├─ BedTimerKit/ (SPM)
│  │  ├─ Sources/
│  │  │  ├─ Core/ (models: BedSession, repositories)
│  │  │  ├─ Sync/ (WCSession, CloudKit adapter)
│  │  │  ├─ Data/ (SwiftData store, migrations)
│  │  │  ├─ Design/ (typography, colors, components)
│  │  │  └─ Utils/ (FeatureFlags, Logging)
│  └─ BedTimerAds/ (SPM; Free-tier only)
├─ Config/
│  ├─ Dev.xcconfig
│  ├─ Staging.xcconfig
│  └─ Prod.xcconfig
├─ Resources/
│  ├─ Localizations/ (en, ko)
│  └─ Assets/ (SF Symbols mapping, Lottie if used)
└─ Tooling/
   ├─ scripts/
   │  ├─ bump_version.sh
   │  └─ gen_strings.sh
   └─ fastlane/
      ├─ Appfile
      ├─ Fastfile
      └─ Matchfile

Architecture: MVVM + Repository.
	•	AlarmRepository (UNUserNotificationCenter wrapper)
	•	SessionRepository (SwiftData CRUD + derived metrics)
	•	SyncService (WatchConnectivity → CloudKit in v2)
	•	FeatureFlags (plist + compile-time flags)

Naming Conventions
	•	Views: ThingView, ViewModels: ThingVM, Repos: ThingRepository.
	•	Modules by feature (Sessions/Alarm/Widgets), not by layer.

⸻

13. GitHub Repo Setup

Branching: Trunk-based with short-lived feature branches.
	•	main → always releasable
	•	feat/<scope>, fix/<scope>, chore/<scope>
	•	Conventional Commits: feat:, fix:, chore:, refactor:, docs:, test:

PR Rules
	•	1+ reviewer approval
	•	CI green (unit + UI tests, lint)
	•	PR template (checklist: tests, localization, accessibility)

Issue Templates
	•	Bug Report, Feature Request, Tech Debt (GitHub Issue Forms)

⸻

14. CI/CD (GitHub Actions → TestFlight)

Workflows
	1.	ios-build-test.yml (PR/Push)

name: iOS Build & Test
on:
  pull_request:
  push:
    branches: [ main ]
jobs:
  build-test:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - uses: maxim-lobanov/setup-xcode@v1
        with: { xcode-version: '16.0' }
      - name: Cache SPM
        uses: actions/cache@v4
        with:
          path: ~/Library/Developer/Xcode/DerivedData
          key: ${{ runner.os }}-spm-${{ hashFiles('**/Package.resolved') }}
      - name: SwiftLint
        uses: norio-nomura/action-swiftlint@3.2.1
        continue-on-error: true
      - name: Build & Test (iOS)
        run: |
          xcodebuild -workspace BedTimer.xcworkspace \
            -scheme BedTimer \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            clean test | xcpretty
      - name: Build (watchOS)
        run: |
          xcodebuild -workspace BedTimer.xcworkspace \
            -scheme BedTimerWatch \
            -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)' \
            build | xcpretty

	2.	release-testflight.yml (tag push v*)

name: Release to TestFlight
on:
  push:
    tags: [ 'v*' ]
jobs:
  release:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - uses: maxim-lobanov/setup-xcode@v1
        with: { xcode-version: '16.0' }
      - name: Decrypt signing
        run: ./Tooling/scripts/decrypt_signing.sh
        env:
          SIGNING_KEY: ${{ secrets.SIGNING_KEY }}
      - name: Fastlane deliver
        run: bundle exec fastlane ios beta
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}

Secrets: APP_STORE_CONNECT_API_KEY, SIGNING_KEY, MATCH_PASSWORD (GitHub Secrets). Signing assets are encrypted in repo or stored via match.

Fastlane (example): lane :beta builds iOS+watchOS, uploads to TestFlight, attaches release notes.

⸻

15. Configuration Management
	•	xcconfig per environment (Dev/Staging/Prod)
	•	FeatureFlags.plist: adsEnabled (Free only), cloudSyncEnabled (Free+), healthKitEnabled (Pro, future)
	•	Info.plist keys: privacy strings (Notifications, HealthKit — conditional), intents descriptions

⸻

16. Ads Integration (Free Tier)
	•	Surfaces: History screen bottom banner only. Never in widgets, complications, notifications, or critical flows.
	•	Providers: AdMob or Apple Ads; no tracking unless ATT opt‑in is required (avoid if possible).
	•	Rate limiting: show after first successful session, max N per day.
	•	Compliance: App Store Review Guidelines, ATT prompts only if using tracking.

⸻

17. Analytics (Privacy‑First)
	•	Defaults: on‑device counters (no PII). Exported only with user consent.
	•	Optional vendor (future): privacy‑friendly metrics (e.g., TelemetryDeck). Disable in Free tier if needed.
	•	KPIs aligned with §9 Success Metrics.

⸻

18. Quality Gates
	•	Code coverage ≥ 80% on core modules (Kit, Sessions, Alarm)
	•	Launch time: iOS ≤ 300 ms to first interactive frame (cold start target), watchOS main view ≤ 500 ms
	•	Accessibility: VoiceOver labels, Dynamic Type AA pass, haptic confirmations

⸻

19. Coding Standards
	•	Swift 5.10+, async/await, Sendable where appropriate
	•	Lint: SwiftLint + SwiftFormat (CI enforced)
	•	Error handling: typed errors for repositories; user‑visible errors localized
	•	Date/time: all logic in UTC, UI localized (24h/12h)
	•	Dependency Injection via protocols; test doubles in Packages/BedTimerKit/Tests

⸻

20. Onboarding (English‑First)
	•	Minimal steps: Notifications permission → Widgets hint → Watch pairing hint
	•	Copy tone: concise, action‑oriented (“Tap I’m up to start your countdown.”)

⸻

21. Repository Hygiene
	•	LICENSE (MIT or Apache‑2.0)
	•	SECURITY.md (reporting policy)
	•	CODE_OF_CONDUCT.md
	•	.editorconfig (tabs/spaces, EOL)
	•	.gitattributes (normalize line endings)
	•	README.md (quick start + screenshots)
	•	CONTRIBUTING.md (PR/branch rules)

⸻

22. Versioning & Releases
	•	SemVer (MAJOR.MINOR.PATCH)
	•	Tag vX.Y.Z → CI Release → TestFlight
	•	Changelog automation (Keep a Changelog format)

⸻

23. Security & Privacy
	•	Least‑privilege entitlements (Notifications, HealthKit optional)
	•	No third‑party SDKs in Watch target unless essential
	•	Data retention: user‑controlled; hard delete honored within 24h of request