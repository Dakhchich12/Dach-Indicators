# 🚦 Dach Indicators ( )

Welcome to **Dach Indicators**! This is a highly optimized, fully standalone vehicle indicator (turn signal) script for FiveM. I built this from the ground up to be as performant as possible (literally 0.00ms resmon idle) while looking super clean and professional.

## ✨ Features
- **True 0.00ms Resmon:** Perfect performance. Uses dynamic thread sleeping so it only uses resources when you actually need it.
- **Native Syncing:** Uses modern FiveM State Bags (`sv_statebag_aware`). No more laggy server events bouncing around.
- **KeyMapped Controls:** Players can change their own keybinds in the GTA V settings! (Default: K, L, H).
- **Animated FX Markers:** Beautiful, blinking, rotating yellow markers that sync perfectly with the native vehicle lights.
- **Instant Audio:** Click-clack indicator sounds play instantly with zero network delay.

## 📥 Installation
1. Download the resource and extract it to your `resources` folder.
2. Ensure the folder is named `dach-Indicators` (or whatever you like, it's standalone!).
3. Add `ensure dach-Indicators` to your `server.cfg`.
4. Restart your server and you're good to go!

## 🎮 How to Use
- **Left Blinker:** Press `Left Arrow`
- **Right Blinker:** Press `Right Arrow`
- **Hazards:** Press `M`
*(Players can change these in GTA V Settings -> Key Bindings -> FiveM)*

## 🛠️ Requirements
- **OneSync** (Enabled by default on 99% of modern servers)
- **FiveM Game Build 2189+** (For State Bag support)

## 📝 Developer Notes
I made this to replace all those old, laggy loop-based indicator scripts. Feel free to edit the code, but please do not re-release it as your own without permission. If you find any bugs, just let me know!


*Created with ❤️ by dakhchich.*
