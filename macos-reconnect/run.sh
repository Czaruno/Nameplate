#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "${1:?Usage: run.sh /absolute/nameplate/repo /absolute/output}" && pwd)
OUTPUT=${2:?Usage: run.sh /absolute/nameplate/repo /absolute/output}
cd "$ROOT"
swift build
BIN=$(swift build --show-bin-path)
SOURCE_DIR=$(cd "$(dirname "$0")" && pwd)
WORK=$(mktemp -d /tmp/nameplate-live-evidence.XXXXXX)
trap 'rm -rf "$WORK"' EXIT

APP="$WORK/NameplateEvidence.app"
mkdir -p "$APP/Contents/MacOS"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>org.nameplate.runtime-evidence</string>
<key>CFBundleExecutable</key><string>NameplateEvidence</string>
<key>LSUIElement</key><true/>
</dict></plist>
PLIST
swiftc -parse-as-library -target "$(uname -m)-apple-macosx15.0" -I "$BIN/Modules" \
  "$SOURCE_DIR/mac.swift" \
  "$ROOT/Sources/Nameplate/AppSettings.swift" "$ROOT/Sources/Nameplate/InfoLineProvider.swift" \
  "$ROOT/Sources/Nameplate/SystemInfo.swift" "$ROOT/Sources/Nameplate/RemoteViewMonitor.swift" \
  "$ROOT/Sources/Nameplate/OverlayController.swift" "$ROOT/Sources/Nameplate/OverlayView.swift" \
  "$ROOT/Sources/Nameplate/NameTagLayout.swift" "$BIN"/NameplateCore.build/*.o \
  -o "$APP/Contents/MacOS/NameplateEvidence"
NAMEPLATE_EVIDENCE_SHA=$(git rev-parse HEAD) NAMEPLATE_EVIDENCE_MIN_PHYSICAL_DISPLAYS=2 NAMEPLATE_EVIDENCE_WATCH_SECONDS=${NAMEPLATE_EVIDENCE_WATCH_SECONDS:-240} "$APP/Contents/MacOS/NameplateEvidence" "$OUTPUT"
