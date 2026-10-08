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
			_ => null,
		};
	}
}
