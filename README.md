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

📦 Preview builds are published on the
[Releases](https://github.com/Mister128/Sync-Music/releases) page.

## Features

**Roadmap**
- [x] Adaptive Samsung Music–style UI: swipeable top tabs on phone, navigation rail on desktop
- [x] Material 3 light/dark themes with a custom brand palette
- [x] Localization: English, Русский
- [x] Local SQLite database (drift) with reactive streams
- [x] Library scanner: folders, tags, cover art, incremental rescan
- [x] Player: queue page, mini-player, full-screen player, background playback and lock-screen/notification controls (Android), last-session restore
- [x] Multi-select everywhere: long-press to select, batch queue / add-to-playlist / delete, action bar replaces the mini-player, navigation locked while selecting
- [x] Playlists: create / rename / delete, drag-and-drop reorder, "add tracks" picker with a filter
- [x] Favorites: heart in the player and in every track menu, dedicated tab
- [x] Instant library search (SQLite FTS5): tracks, albums, artists — matches as you type, Cyrillic included
- [x] Permanent track deletion: files are removed from disk (system dialog on Android)
- [ ] **P2P sync over LAN**: mDNS discovery, QR pairing, encrypted operation-log sync, file transfer with resume

If had time:
- [ ] Party mode (synchronized playback)

## Tech stack

|     Layer    |                         Choice                         |
|:------------:|:------------------------------------------------------:|
|  State / DI  |                       Riverpod 3                       |
|   Database   |               drift (SQLite) + FTS5 search             |
|  Navigation  |                       go_router                        |
|     i18n     |                         slang                          |
|   Logging    |                         talker                         |
| Audio engine |       just_audio (media_kit on Windows desktop)        |
|  Audio tags  |           audio_metadata_reader (pure Dart)            |
| P2P (planned)| bonsoir (mDNS) + custom op-log sync engine (HLC + LWW) |

## Getting started

Prerequisites: Flutter stable with Android and Windows desktop support
(`flutter doctor` should be happy).

```bash
git clone https://github.com/Mister128/Sync-Music.git
cd Sync-Music
flutter pub get
dart run build_runner build                               # i18n + drift codegen
flutter run
```

## Project structure

```
lib/
├── app/        # wiring: router, adaptive shell, sections
├── core/       # shared kernel: database, design system, selection, logging, utils
├── features/   # library / player / playlists / search / settings
│   └── <feature>/{domain, data, presentation}
└── i18n/       # translations (slang, generated strings.g.dart)
```

Clean architecture: `presentation -> domain <- data`. Features never import each other.

## Development

```bash
dart run build_runner watch                               # codegen while you work
dart run slang analyze                                    # unused translations
flutter test
```

## License

[MIT LICENSE](LICENSE)