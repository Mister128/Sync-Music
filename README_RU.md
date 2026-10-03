<div align="center">

# 🎵 Sync Music

**Музыкальный плеер с плейлистами во главе угла и P2P-синхронизацией
между вашими устройствами. Без облака. Без аккаунтов. Музыка не покидает ваши устройства.**

![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?style=flat&logo=dart&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-46af0a.svg)](LICENSE)
![Platforms](https://img.shields.io/badge/platforms-Android%20%C2%B7%20Desktop-087d5a)
![Status](https://img.shields.io/badge/status-in_development-yellow?style=flat)

[English](README.md) | [Русский](README_RU.md)

</div>

---

Sync Music сканирует локальную музыкальную библиотеку и синхронизирует
плейлисты, избранное и позицию воспроизведения между телефоном и ПК
напрямую по локальной сети.

## Возможности

**Дорожная карта**
- [x] Адаптивный UI в духе Samsung Music: свайпаемые табы сверху на телефоне, navigation rail на десктопе
- [x] Светлая/тёмная темы Material 3 с брендовой палитрой
- [x] Локализация: English, Русский
- [x] Локальная база SQLite (drift) с реактивными стримами
- [ ] Сканер библиотеки: папки, теги, обложки, инкрементальное пересканирование
- [ ] Плеер: очередь, мини-плеер, фоновое воспроизведение, управление с экрана блокировки
- [ ] Плейлисты: drag-and-drop, избранное, поиск
- [ ] **P2P-синхронизация по локальной сети**: mDNS-discovery, QR-pairing, шифрованный operation-log sync, передача файлов с докачкой

Если будет время:
- [ ] Party mode (синхронное воспроизведение)

## Стек

|    Слой     |                       Решение                        |
|:-----------:|:----------------------------------------------------:|
| State / DI  |                      Riverpod 3                      |
| База данных |                    drift (SQLite)                    |
|  Навигация  |                      go_router                       |
| Локализация |                        slang                         |
| Логирование |                        talker                        |
| Аудио-теги  |         audio_metadata_reader (чистый Dart)          |
| P2P (план)  | bonsoir (mDNS) + собственный sync-движок (HLC + LWW) |

## Запуск

Требуется: Flutter stable с поддержкой Android и Windows desktop
(`flutter doctor` без ошибок).

```bash
git clone https://github.com/Mister128/Sync-Music.git
cd Sync-Music
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # кодогенерация i18n + drift
flutter run
```

## Структура проекта

```
lib/
├── app/        # склейка: роутер, адаптивная оболочка, корневой виджет
├── core/       # общее ядро: база, дизайн-система, логирование, утилиты
├── features/   # library / playlists / player / sync / settings
│   └── <фича>/{domain, data, presentation}
└── i18n/       # переводы (slang, генерируемый strings.g.dart)
```

Clean architecture: `presentation -> domain <- data`. Фичи не импортируют друг друга.

## Разработка

```bash
dart run build_runner watch --delete-conflicting-outputs  # кодоген на лету
dart run slang analyze                                    # неиспользуемые переводы
flutter test
```

## Лицензия

[MIT LICENSE](LICENSE)