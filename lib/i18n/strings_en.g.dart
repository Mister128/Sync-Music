///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$nav$en nav = Translations$nav$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$library$en library = Translations$library$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sync Music'
	String get title => 'Sync Music';
}

// Path: nav
class Translations$nav$en {
	Translations$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Playlists'
	String get playlists => 'Playlists';

	/// en: 'Tracks'
	String get tracks => 'Tracks';

	/// en: 'Albums'
	String get albums => 'Albums';

	/// en: 'Artists'
	String get artists => 'Artists';
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'In Development'
	String get inDevelopment => 'In Development';

	/// en: 'Something went wrong'
	String get error => 'Something went wrong';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Auto'
	String get themeSystem => 'Auto';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Debug'
	String get debug => 'Debug';

	/// en: 'Logs'
	String get debugLogs => 'Logs';

	/// en: 'In-app log viewer'
	String get debugLogsSubtitle => 'In-app log viewer';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Library'
	String get library => 'Library';

	/// en: 'No music folders yet'
	String get libraryEmpty => 'No music folders yet';

	/// en: 'Add a folder to build your collection'
	String get libraryEmptyHint => 'Add a folder to build your collection';

	/// en: 'Add folder'
	String get addFolder => 'Add folder';

	/// en: 'Choose a music folder'
	String get addFolderDialog => 'Choose a music folder';

	/// en: 'Not scanned yet'
	String get notScanned => 'Not scanned yet';

	/// en: 'Scanned $date'
	String lastScanned({required Object date}) => 'Scanned ${date}';

	/// en: 'Remove'
	String get removeFolder => 'Remove';

	/// en: 'Scan library now'
	String get scanNow => 'Scan library now';
}

// Path: library
class Translations$library$en {
	Translations$library$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No tracks yet'
	String get tracksEmpty => 'No tracks yet';

	/// en: 'Add music or music folder in Settings'
	String get tracksEmptyHint => 'Add music or music folder in Settings';

	/// en: 'Scanning... $processed of $total'
	String scanning({required Object processed, required Object total}) => 'Scanning... ${processed} of ${total}';

	/// en: 'No albums yet'
	String get albumsEmpty => 'No albums yet';

	/// en: 'No artists yet'
	String get artistsEmpty => 'No artists yet';

	/// en: '(one) {$count track} (other) {$count tracks}'
	String trackCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} track',
		other: '${count} tracks',
	);

	/// en: '(one) {$count album} (other) {$count albums}'
	String albumCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} album',
		other: '${count} albums',
	);
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Sync Music',
			'nav.favorites' => 'Favorites',
			'nav.playlists' => 'Playlists',
			'nav.tracks' => 'Tracks',
			'nav.albums' => 'Albums',
			'nav.artists' => 'Artists',
			'common.inDevelopment' => 'In Development',
			'common.error' => 'Something went wrong',
			'settings.title' => 'Settings',
			'settings.appearance' => 'Appearance',
			'settings.theme' => 'Theme',
			'settings.themeSystem' => 'Auto',
			'settings.themeLight' => 'Light',
			'settings.themeDark' => 'Dark',
			'settings.language' => 'Language',
			'settings.debug' => 'Debug',
			'settings.debugLogs' => 'Logs',
			'settings.debugLogsSubtitle' => 'In-app log viewer',
			'settings.about' => 'About',
			'settings.version' => 'Version',
			'settings.library' => 'Library',
			'settings.libraryEmpty' => 'No music folders yet',
			'settings.libraryEmptyHint' => 'Add a folder to build your collection',
			'settings.addFolder' => 'Add folder',
			'settings.addFolderDialog' => 'Choose a music folder',
			'settings.notScanned' => 'Not scanned yet',
			'settings.lastScanned' => ({required Object date}) => 'Scanned ${date}',
			'settings.removeFolder' => 'Remove',
			'settings.scanNow' => 'Scan library now',
			'library.tracksEmpty' => 'No tracks yet',
			'library.tracksEmptyHint' => 'Add music or music folder in Settings',
			'library.scanning' => ({required Object processed, required Object total}) => 'Scanning... ${processed} of ${total}',
			'library.albumsEmpty' => 'No albums yet',
			'library.artistsEmpty' => 'No artists yet',
			'library.trackCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} track', other: '${count} tracks', ), 
			'library.albumCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} album', other: '${count} albums', ), 
			_ => null,
		};
	}
}
