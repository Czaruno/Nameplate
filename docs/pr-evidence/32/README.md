# PR #32 native macOS behavior proof

Captured from PR head `b6966fbda31fbd5d14123b1305c960c3fa8bb081` on macOS 15.7.2 (24G325), using the ad-hoc-signed debug `Nameplate.app` and its real full-screen `OverlayView` panel.

The background is a temporary native 1920×1080 grid window (20 pt minor grid, 100 pt major grid). Screenshots are direct 650×300 screen captures of its lower-left corner; they contain no user desktop content. The production Nameplate process and Dock settings were restored after capture.

## Cases

1. `01-zero-offset.png` — horizontal `0`, vertical `0`; preserves the existing base corner placement.
2. `02-horizontal-120.png` — horizontal `120`, vertical `0`; only the x position moves inward by 120 pt.
3. `03-vertical-60.png` — horizontal `0`, vertical `60`; only the y position moves inward by 60 pt.
4. `04-persisted-relaunch-120-60.png` — horizontal `120`, vertical `60`; captured after terminating and relaunching the app without rewriting preferences.

Immediately before the second launch in case 4, the persisted debug-domain values were read back as:

```text
tagHorizontalOffset = 120
tagVerticalOffset = 60
```

## SHA-256

```text
45493f9bcab987acf88fcb60f51ccaa18f277de7cd18bdb143fbdc0f007aa232  01-zero-offset.png
bb177d5a4dcf03c5e7020dcd22a25e61f9b64d0bc14d59ff3d84d4c1befdfe89  02-horizontal-120.png
d0f6581e702248f33823ef66019473b5cb53a06840d56d389c2349b4ea98fce4  03-vertical-60.png
770e81846a114d20b900934c2ba94b1d60b630a41406e81d5f9f6ddd0ddefd3a  04-persisted-relaunch-120-60.png
```
