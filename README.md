# Dream Interpreter

A native iOS app (Swift / SwiftUI, iOS 17+) that lets you record a dream in seconds and receive one calm, honest reading synthesized from six interpretive traditions, with a private on-device journal that reveals patterns over time.

Product truth, architecture, and the active plan live in **`PDD.md`** — read it first. The visual reference is `design/prototype.jsx` (web prototype, not shipping code).

## Setup

Requires Xcode 16.x with the iOS 17 SDK.

```bash
open DreamInterpreter.xcodeproj
```

Or from the command line:

```bash
xcodebuild -scheme DreamInterpreter -destination 'platform=iOS Simulator,name=iPhone 15' build
```

Run tests:

```bash
xcodebuild test -scheme DreamInterpreter -only-testing:DreamInterpreterTests -destination 'platform=iOS Simulator,name=iPhone 15'
xcodebuild test -scheme DreamInterpreter -only-testing:DreamInterpreterUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Structure

- `DreamInterpreter/` — SwiftUI app source (App entry, Core, Features)
- `DreamInterpreterTests/` — unit tests
- `DreamInterpreterUITests/` — UI flow tests
- `design/prototype.jsx` — canonical design reference ("night garden" system)
- `PDD.md` — product source of truth for humans and agents
