# Live physical monitor reconnect evidence

On October 1, 2026, the user disconnected and reconnected the USB display adapter for one HP monitor on the Mac console. The same production OverlayController remained running throughout. It handled the actual screen-change notifications; the harness did not invoke rebuildPanels or applyVisibility after hardware changes.

The recorded display count was **3 → 2 → 3**. Every stage has native screenshots and photographed pill bounds. After each change, the harness also asserted that visible production panel frames matched the actual screen frames, panel count matched display count, all panels retained status-bar level, and their click-through flags stayed enabled. All physical displays were at 1×.

The tags use **Right center with offsets 0,0**. Photographed pill centers differed from each screen midpoint by 0.5 pixel, consistent with rasterization of an odd-height pill; the earlier exploratory run used vertical −100 and intentionally sat above the midpoint.

See [display-changes.json](./display-changes.json) for revisions, frames, display identity/classification, offsets, and pixel measurements. The successful harness uses the native NSApplication event loop and awaits between polls so the main queue can deliver display notifications and scheduled frame synchronization. It shows hardware-action instructions on its own synthetic backdrops so the user can follow them while the desktop is covered.

To reproduce, use a Nameplate checkout at the recorded production revision with the physical monitors already connected:

```sh
bash run.sh /absolute/path/to/Nameplate /absolute/path/to/output
```

Screen Recording permission is required. Follow the instructions shown on the test screen: disconnect a secondary monitor's video cable or USB display adapter, wait ten seconds, then reconnect it. The app closes on completion or after its four-minute timeout. The harness links the production controller and views, uses an isolated bundle identifier and synthetic identity, and captures only its backdrop and production overlay windows.

This verifies real hardware disconnect/reconnect, including layouts with negative and positive horizontal origins. It does not assert manual monitor dragging, mixed-scale physical hardware, notch hardware, or Windows/Linux physical multi-monitor coverage.
