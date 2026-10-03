<div align="center">

# 🎵 Sync Music

**Playlist-first music player with P2P sync between your devices.
No cloud. No accounts. Your music never leaves your hardware.**

![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?style=flat&logo=dart&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-46af0a.svg)](LICENSE)
![Platforms](https://img.shields.io/badge/platforms-Android%20%C2%B7%20Desktop-087d5a)
![Status](https://img.shields.io/badge/status-in_development-yellow?style=flat)

[English](README.md) | [Русский](README_RU.md)

</div>


---

Sync Music scans your local music library and keeps playlists, favorites and
playback position in sync between phone and PC directly over the local network.

## Features

**Roadmap**
- [x] Adaptive Samsung Music–style UI: swipeable top tabs on phone, navigation rail on desktop
- [x] Material 3 light/dark themes with a custom brand palette
- [x] Localization: English, Русский
- [x] Local SQLite database (drift) with reactive streams
- [ ] Library scanner: folders, tags, cover art, incremental rescan
- [ ] Player: queue, mini-player, background playback, lock-screen controls
- [ ] Playlists: drag-and-drop reorder, favorites, search
- [ ] **P2P sync over LAN**: mDNS discovery, QR pairing, encrypted operation-log sync, file transfer with resume

If had time:
- [ ] Party mode (synchronized playback)

## Tech stack

|     Layer     |                         Choice                         |
|:-------------:|:------------------------------------------------------:|
|  State / DI   |                       Riverpod 3                       |
|   Database    |                     drift (SQLite)                     |
|  Navigation   |                       go_router                        |
|     i18n      |                         slang                          |
|    Logging    |                         talker                         |
|  Audio tags   |           audio_metadata_reader (pure Dart)            |
| P2P (planned) | bonsoir (mDNS) + custom op-log sync engine (HLC + LWW) |

## Getting started

Prerequisites: Flutter stable with Android and Windows desktop support
(`flutter doctor` should be happy).

```bash
git clone https://github.com/Mister128/Sync-Music.git
cd Sync-Music
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # i18n + drift codegen
flutter run
```

## Project structure

```
lib/
├── app/        # wiring: router, adaptive shell, root widget
├── core/       # shared kernel: database, design system, logging, utils
├── features/   # library / playlists / player / sync / settings
│   └── <feature>/{domain, data, presentation}
└── i18n/       # translations (slang, generated strings.g.dart)
```

Clean architecture: `presentation -> domain <- data`. Features never import each other.

## Development

```bash
dart run build_runner watch --delete-conflicting-outputs  # codegen while you work
dart run slang analyze                                    # unused translations
flutter test
```

## License

[MIT LICENSE](LICENSE)