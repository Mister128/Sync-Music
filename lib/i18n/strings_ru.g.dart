///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$ru app = _Translations$app$ru._(_root);
	@override late final _Translations$nav$ru nav = _Translations$nav$ru._(_root);
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$settings$ru settings = _Translations$settings$ru._(_root);
	@override late final _Translations$library$ru library = _Translations$library$ru._(_root);
	@override late final _Translations$player$ru player = _Translations$player$ru._(_root);
	@override late final _Translations$playlists$ru playlists = _Translations$playlists$ru._(_root);
	@override late final _Translations$favorites$ru favorites = _Translations$favorites$ru._(_root);
	@override late final _Translations$search$ru search = _Translations$search$ru._(_root);
	@override late final _Translations$selection$ru selection = _Translations$selection$ru._(_root);
}

// Path: app
class _Translations$app$ru extends Translations$app$en {
	_Translations$app$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sync Music';
}

// Path: nav
class _Translations$nav$ru extends Translations$nav$en {
	_Translations$nav$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get favorites => 'Избранное';
	@override String get playlists => 'Плейлисты';
	@override String get tracks => 'Треки';
	@override String get albums => 'Альбомы';
	@override String get artists => 'Артисты';
}

// Path: common
class _Translations$common$ru extends Translations$common$en {
	_Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get inDevelopment => 'В разработке';
	@override String get error => 'Что-то пошло не так';
	@override String get cancel => 'Отмена';
	@override String get save => 'Сохранить';
	@override String get delete => 'Удалить';
}

// Path: settings
class _Translations$settings$ru extends Translations$settings$en {
	_Translations$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override String get appearance => 'Оформление';
	@override String get theme => 'Тема';
	@override String get themeSystem => 'Системная';
	@override String get themeLight => 'Светлая';
	@override String get themeDark => 'Тёмная';
	@override String get language => 'Язык';
	@override String get debug => 'Отладка';
	@override String get debugLogs => 'Логи';
	@override String get debugLogsSubtitle => 'Встроенный журнал логов';
	@override String get about => 'О приложении';
	@override String get version => 'Версия';
	@override String get library => 'Библиотека';
	@override String get libraryEmpty => 'Ещё нет папок с музыкой';
	@override String get libraryEmptyHint => 'Добавьте папку, чтобы собрать коллекцию';
	@override String get addFolder => 'Добавить папку';
	@override String get addFolderDialog => 'Выберите папку с музыкой';
	@override String get notScanned => 'Ещё не сканировалась';
	@override String lastScanned({required Object date}) => 'Сканировано ${date}';
	@override String get removeFolder => 'Убрать';
	@override String get scanNow => 'Сканировать библиотеку';
	@override String get androidSourceTitle => 'Системная медиатека';
	@override String get androidSourceSubtitle => 'Сканируется всё, что знает MediaStore — выбирать папки не нужно';
	@override String get grantAudioAccess => 'Разрешить доступ к аудио';
	@override String get audioAccessGranted => 'Доступ к аудио разрешён';
}

// Path: library
class _Translations$library$ru extends Translations$library$en {
	_Translations$library$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get tracksEmpty => 'Нет треков';
	@override String get tracksEmptyHint => 'Добавьте музыку или папку с музыкой в настройках';
	@override String scanning({required Object processed, required Object total}) => 'Сканирование... ${processed} из ${total}';
	@override String get albumsEmpty => 'Пока нет альбомов';
	@override String get artistsEmpty => 'Пока нет артистов';
	@override String trackCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} трек',
		few: '${count} трека',
		many: '${count} треков',
		other: '${count} треков',
	);
	@override String albumCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} альбом',
		few: '${count} альбома',
		many: '${count} альбомов',
		other: '${count} альбомов',
	);
	@override String get deleteConfirmTitle => 'Удалить трек?';
	@override String deleteConfirmMessage({required Object title}) => '«${title}» будет навсегда удалён с диска. Это действие необратимо.';
	@override String get deleteConfirmAction => 'Удалить';
	@override String get deleted => 'Трек удалён';
	@override String get deleteFailed => 'Не удалось удалить трек';
	@override String deleteConfirmTitleBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Удалить ${count} трек?',
		few: 'Удалить ${count} трека?',
		many: 'Удалить ${count} треков?',
		other: 'Удалить ${count} треков?',
	);
	@override String get deleteConfirmMessageBatch => 'Выбранные треки будут навсегда удалены с диска. Это действие необратимо.';
	@override String deletedBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Удалён ${count} трек',
		few: 'Удалено ${count} трека',
		many: 'Удалено ${count} треков',
		other: 'Удалено ${count} треков',
	);
	@override String deleteFailedBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Не удалось удалить ${count} трек',
		few: 'Не удалось удалить ${count} трека',
		many: 'Не удалось удалить ${count} треков',
		other: 'Не удалось удалить ${count} треков',
	);
}

// Path: player
class _Translations$player$ru extends Translations$player$en {
	_Translations$player$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get play => 'Воспроизвести';
	@override String get pause => 'Пауза';
	@override String get next => 'Следующий трек';
	@override String get previous => 'Предыдущий трек';
	@override String get miniPlayerEmpty => 'Включите трек - он появится здесь';
	@override String get playNext => 'Воспроизвести следующим';
	@override String get addToQueue => 'Добавить в очередь';
	@override String get queue => 'Очередь';
	@override String get queueEmpty => 'Очередь пуста';
	@override String get removeFromQueue => 'Убрать из очереди';
	@override String get nowPlaying => 'Сейчас играет';
	@override String get closePlayer => 'Закрыть плеер';
	@override String get shuffle => 'Перемешать';
	@override String get repeatOff => 'Повтор выключен';
	@override String get repeatAll => 'Повторять все';
	@override String get repeatOne => 'Повторять трек';
}

// Path: playlists
class _Translations$playlists$ru extends Translations$playlists$en {
	_Translations$playlists$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get create => 'Новый плейлист';
	@override String get rename => 'Переименовать плейлист';
	@override String get delete => 'Удалить';
	@override String get deleteConfirmTitle => 'Удалить плейлист?';
	@override String deleteConfirmMessage({required Object name}) => '«${name}» будет удалён. Треки останутся в библиотеке.';
	@override String get deleteConfirmAction => 'Удалить';
	@override String get nameLabel => 'Название';
	@override String get nameEmpty => 'Введите название';
	@override String get empty => 'Пока нет плейлистов';
	@override String get emptyHint => 'Создайте первый плейлист';
	@override String trackCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} трек',
		few: '${count} трека',
		many: '${count} треков',
		other: '${count} трека',
	);
	@override String get addToPlaylist => 'Добавить в плейлист';
	@override String get emptyPlaylist => 'В плейлисте пока пусто';
	@override String get emptyPlaylistHint => 'Добавляйте треки долгим нажатием в библиотеке';
	@override String get removeFromPlaylist => 'Убрать из плейлиста';
	@override String get addTracks => 'Добавить треки';
	@override String addTracksCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Добавить ${count} трек',
		few: 'Добавить ${count} трека',
		many: 'Добавить ${count} треков',
		other: 'Добавить ${count} трека',
	);
	@override String addedCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Добавлен ${count} трек',
		few: 'Добавлено ${count} трека',
		many: 'Добавлено ${count} треков',
		other: 'Добавлено ${count} трека',
	);
}

// Path: favorites
class _Translations$favorites$ru extends Translations$favorites$en {
	_Translations$favorites$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addToFavorites => 'Добавить в избранное';
	@override String get removeFromFavorites => 'Убрать из избранного';
	@override String get empty => 'В избранном пока пусто';
	@override String get emptyHint => 'Нажмите на сердце в плеере или в меню трека';
}

// Path: search
class _Translations$search$ru extends Translations$search$en {
	_Translations$search$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Поиск';
	@override String get hint => 'Треки, альбомы, артисты';
	@override String get clear => 'Очистить';
	@override String get startHint => 'Ищите по своей библиотеке';
	@override String noResults({required Object query}) => 'По запросу «${query}» ничего не найдено';
	@override String get filterTracks => 'Поиск по трекам';
}

// Path: selection
class _Translations$selection$ru extends Translations$selection$en {
	_Translations$selection$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String selectedCount({required Object count}) => 'Выбрано: ${count}';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Sync Music',
			'nav.favorites' => 'Избранное',
			'nav.playlists' => 'Плейлисты',
			'nav.tracks' => 'Треки',
			'nav.albums' => 'Альбомы',
			'nav.artists' => 'Артисты',
			'common.inDevelopment' => 'В разработке',
			'common.error' => 'Что-то пошло не так',
			'common.cancel' => 'Отмена',
			'common.save' => 'Сохранить',
			'common.delete' => 'Удалить',
			'settings.title' => 'Настройки',
			'settings.appearance' => 'Оформление',
			'settings.theme' => 'Тема',
			'settings.themeSystem' => 'Системная',
			'settings.themeLight' => 'Светлая',
			'settings.themeDark' => 'Тёмная',
			'settings.language' => 'Язык',
			'settings.debug' => 'Отладка',
			'settings.debugLogs' => 'Логи',
			'settings.debugLogsSubtitle' => 'Встроенный журнал логов',
			'settings.about' => 'О приложении',
			'settings.version' => 'Версия',
			'settings.library' => 'Библиотека',
			'settings.libraryEmpty' => 'Ещё нет папок с музыкой',
			'settings.libraryEmptyHint' => 'Добавьте папку, чтобы собрать коллекцию',
			'settings.addFolder' => 'Добавить папку',
			'settings.addFolderDialog' => 'Выберите папку с музыкой',
			'settings.notScanned' => 'Ещё не сканировалась',
			'settings.lastScanned' => ({required Object date}) => 'Сканировано ${date}',
			'settings.removeFolder' => 'Убрать',
			'settings.scanNow' => 'Сканировать библиотеку',
			'settings.androidSourceTitle' => 'Системная медиатека',
			'settings.androidSourceSubtitle' => 'Сканируется всё, что знает MediaStore — выбирать папки не нужно',
			'settings.grantAudioAccess' => 'Разрешить доступ к аудио',
			'settings.audioAccessGranted' => 'Доступ к аудио разрешён',
			'library.tracksEmpty' => 'Нет треков',
			'library.tracksEmptyHint' => 'Добавьте музыку или папку с музыкой в настройках',
			'library.scanning' => ({required Object processed, required Object total}) => 'Сканирование... ${processed} из ${total}',
			'library.albumsEmpty' => 'Пока нет альбомов',
			'library.artistsEmpty' => 'Пока нет артистов',
			'library.trackCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} трек', few: '${count} трека', many: '${count} треков', other: '${count} треков', ), 
			'library.albumCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} альбом', few: '${count} альбома', many: '${count} альбомов', other: '${count} альбомов', ), 
			'library.deleteConfirmTitle' => 'Удалить трек?',
			'library.deleteConfirmMessage' => ({required Object title}) => '«${title}» будет навсегда удалён с диска. Это действие необратимо.',
			'library.deleteConfirmAction' => 'Удалить',
			'library.deleted' => 'Трек удалён',
			'library.deleteFailed' => 'Не удалось удалить трек',
			'library.deleteConfirmTitleBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Удалить ${count} трек?', few: 'Удалить ${count} трека?', many: 'Удалить ${count} треков?', other: 'Удалить ${count} треков?', ), 
			'library.deleteConfirmMessageBatch' => 'Выбранные треки будут навсегда удалены с диска. Это действие необратимо.',
			'library.deletedBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Удалён ${count} трек', few: 'Удалено ${count} трека', many: 'Удалено ${count} треков', other: 'Удалено ${count} треков', ), 
			'library.deleteFailedBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Не удалось удалить ${count} трек', few: 'Не удалось удалить ${count} трека', many: 'Не удалось удалить ${count} треков', other: 'Не удалось удалить ${count} треков', ), 
			'player.play' => 'Воспроизвести',
			'player.pause' => 'Пауза',
			'player.next' => 'Следующий трек',
			'player.previous' => 'Предыдущий трек',
			'player.miniPlayerEmpty' => 'Включите трек - он появится здесь',
			'player.playNext' => 'Воспроизвести следующим',
			'player.addToQueue' => 'Добавить в очередь',
			'player.queue' => 'Очередь',
			'player.queueEmpty' => 'Очередь пуста',
			'player.removeFromQueue' => 'Убрать из очереди',
			'player.nowPlaying' => 'Сейчас играет',
			'player.closePlayer' => 'Закрыть плеер',
			'player.shuffle' => 'Перемешать',
			'player.repeatOff' => 'Повтор выключен',
			'player.repeatAll' => 'Повторять все',
			'player.repeatOne' => 'Повторять трек',
			'playlists.create' => 'Новый плейлист',
			'playlists.rename' => 'Переименовать плейлист',
			'playlists.delete' => 'Удалить',
			'playlists.deleteConfirmTitle' => 'Удалить плейлист?',
			'playlists.deleteConfirmMessage' => ({required Object name}) => '«${name}» будет удалён. Треки останутся в библиотеке.',
			'playlists.deleteConfirmAction' => 'Удалить',
			'playlists.nameLabel' => 'Название',
			'playlists.nameEmpty' => 'Введите название',
			'playlists.empty' => 'Пока нет плейлистов',
			'playlists.emptyHint' => 'Создайте первый плейлист',
			'playlists.trackCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} трек', few: '${count} трека', many: '${count} треков', other: '${count} трека', ), 
			'playlists.addToPlaylist' => 'Добавить в плейлист',
			'playlists.emptyPlaylist' => 'В плейлисте пока пусто',
			'playlists.emptyPlaylistHint' => 'Добавляйте треки долгим нажатием в библиотеке',
			'playlists.removeFromPlaylist' => 'Убрать из плейлиста',
			'playlists.addTracks' => 'Добавить треки',
			'playlists.addTracksCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Добавить ${count} трек', few: 'Добавить ${count} трека', many: 'Добавить ${count} треков', other: 'Добавить ${count} трека', ), 
			'playlists.addedCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Добавлен ${count} трек', few: 'Добавлено ${count} трека', many: 'Добавлено ${count} треков', other: 'Добавлено ${count} трека', ), 
			'favorites.addToFavorites' => 'Добавить в избранное',
			'favorites.removeFromFavorites' => 'Убрать из избранного',
			'favorites.empty' => 'В избранном пока пусто',
			'favorites.emptyHint' => 'Нажмите на сердце в плеере или в меню трека',
			'search.title' => 'Поиск',
			'search.hint' => 'Треки, альбомы, артисты',
			'search.clear' => 'Очистить',
			'search.startHint' => 'Ищите по своей библиотеке',
			'search.noResults' => ({required Object query}) => 'По запросу «${query}» ничего не найдено',
			'search.filterTracks' => 'Поиск по трекам',
			'selection.selectedCount' => ({required Object count}) => 'Выбрано: ${count}',
			_ => null,
		};
	}
}
