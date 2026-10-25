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
	late final Translations$player$en player = Translations$player$en.internal(_root);
	late final Translations$playlists$en playlists = Translations$playlists$en.internal(_root);
	late final Translations$favorites$en favorites = Translations$favorites$en.internal(_root);
	late final Translations$search$en search = Translations$search$en.internal(_root);
	late final Translations$selection$en selection = Translations$selection$en.internal(_root);
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

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';
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

	/// en: 'System media library'
	String get androidSourceTitle => 'System media library';

	/// en: 'Everything MediaStore knows is scanned'
	String get androidSourceSubtitle => 'Everything MediaStore knows is scanned';

	/// en: 'Grant audio access'
	String get grantAudioAccess => 'Grant audio access';

	/// en: 'Audio access granted'
	String get audioAccessGranted => 'Audio access granted';
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

	/// en: 'Delete track?'
	String get deleteConfirmTitle => 'Delete track?';

	/// en: '"$title" will be permanently deleted from disk. This cannot be undone.'
	String deleteConfirmMessage({required Object title}) => '"${title}" will be permanently deleted from disk. This cannot be undone.';

	/// en: 'Delete'
	String get deleteConfirmAction => 'Delete';

	/// en: 'Track deleted'
	String get deleted => 'Track deleted';

	/// en: 'Couldn't delete the track'
	String get deleteFailed => 'Couldn\'t delete the track';

	/// en: '(one) {Delete $count track?} (other) {Delete $count tracks?}'
	String deleteConfirmTitleBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Delete ${count} track?',
		other: 'Delete ${count} tracks?',
	);

	/// en: 'The selected tracks will be permanently deleted from disk. This cannot be undone.'
	String get deleteConfirmMessageBatch => 'The selected tracks will be permanently deleted from disk. This cannot be undone.';

	/// en: '(one) {$count track deleted} (other) {$count tracks deleted}'
	String deletedBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} track deleted',
		other: '${count} tracks deleted',
	);

	/// en: '(one) {Couldn't delete $count track} (other) {Couldn't delete $count tracks}'
	String deleteFailedBatch({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Couldn\'t delete ${count} track',
		other: 'Couldn\'t delete ${count} tracks',
	);
}

// Path: player
class Translations$player$en {
	Translations$player$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Play'
	String get play => 'Play';

	/// en: 'Pause'
	String get pause => 'Pause';

	/// en: 'Next track'
	String get next => 'Next track';

	/// en: 'Previous track'
	String get previous => 'Previous track';

	/// en: 'Play something - it will show up here'
	String get miniPlayerEmpty => 'Play something - it will show up here';

	/// en: 'Play next'
	String get playNext => 'Play next';

	/// en: 'Add to queue'
	String get addToQueue => 'Add to queue';

	/// en: 'Queue'
	String get queue => 'Queue';

	/// en: 'The queue is empty'
	String get queueEmpty => 'The queue is empty';

	/// en: 'Remove from queue'
	String get removeFromQueue => 'Remove from queue';

	/// en: 'Now playing'
	String get nowPlaying => 'Now playing';

	/// en: 'Close player'
	String get closePlayer => 'Close player';

	/// en: 'Shuffle'
	String get shuffle => 'Shuffle';

	/// en: 'Repeat off'
	String get repeatOff => 'Repeat off';

	/// en: 'Repeat all'
	String get repeatAll => 'Repeat all';

	/// en: 'Repeat one'
	String get repeatOne => 'Repeat one';
}

// Path: playlists
class Translations$playlists$en {
	Translations$playlists$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New playlist'
	String get create => 'New playlist';

	/// en: 'Rename playlist'
	String get rename => 'Rename playlist';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete playlist?'
	String get deleteConfirmTitle => 'Delete playlist?';

	/// en: '"$name" will be deleted. Its tracks stay in the library.'
	String deleteConfirmMessage({required Object name}) => '"${name}" will be deleted. Its tracks stay in the library.';

	/// en: 'Delete'
	String get deleteConfirmAction => 'Delete';

	/// en: 'Name'
	String get nameLabel => 'Name';

	/// en: 'Enter a name'
	String get nameEmpty => 'Enter a name';

	/// en: 'No playlists yet'
	String get empty => 'No playlists yet';

	/// en: 'Create your first playlist'
	String get emptyHint => 'Create your first playlist';

	/// en: '(one) {$count track} (other) {$count tracks}'
	String trackCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} track',
		other: '${count} tracks',
	);

	/// en: 'Add to playlist'
	String get addToPlaylist => 'Add to playlist';

	/// en: 'No tracks yet'
	String get emptyPlaylist => 'No tracks yet';

	/// en: 'Add tracks via long-press in the library'
	String get emptyPlaylistHint => 'Add tracks via long-press in the library';

	/// en: 'Remove from playlist'
	String get removeFromPlaylist => 'Remove from playlist';

	/// en: 'Add tracks'
	String get addTracks => 'Add tracks';

	/// en: '(one) {Add $count track} (other) {Add $count tracks}'
	String addTracksCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Add ${count} track',
		other: 'Add ${count} tracks',
	);

	/// en: '(one) {$count track added} (other) {$count tracks added}'
	String addedCount({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${count} track added',
		other: '${count} tracks added',
	);
}

// Path: favorites
class Translations$favorites$en {
	Translations$favorites$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to favorites'
	String get addToFavorites => 'Add to favorites';

	/// en: 'Remove from favorites'
	String get removeFromFavorites => 'Remove from favorites';

	/// en: 'No favorites yet'
	String get empty => 'No favorites yet';

	/// en: 'Tap the heart in the player or in a track's menu'
	String get emptyHint => 'Tap the heart in the player or in a track\'s menu';
}

// Path: search
class Translations$search$en {
	Translations$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get title => 'Search';

	/// en: 'Tracks, albums, artists'
	String get hint => 'Tracks, albums, artists';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Search your library'
	String get startHint => 'Search your library';

	/// en: 'Nothing found for "$query"'
	String noResults({required Object query}) => 'Nothing found for "${query}"';

	/// en: 'Filter tracks'
	String get filterTracks => 'Filter tracks';
}

// Path: selection
class Translations$selection$en {
	Translations$selection$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$count selected'
	String selectedCount({required Object count}) => '${count} selected';
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
			'common.cancel' => 'Cancel',
			'common.save' => 'Save',
			'common.delete' => 'Delete',
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
			'settings.androidSourceTitle' => 'System media library',
			'settings.androidSourceSubtitle' => 'Everything MediaStore knows is scanned',
			'settings.grantAudioAccess' => 'Grant audio access',
			'settings.audioAccessGranted' => 'Audio access granted',
			'library.tracksEmpty' => 'No tracks yet',
			'library.tracksEmptyHint' => 'Add music or music folder in Settings',
			'library.scanning' => ({required Object processed, required Object total}) => 'Scanning... ${processed} of ${total}',
			'library.albumsEmpty' => 'No albums yet',
			'library.artistsEmpty' => 'No artists yet',
			'library.trackCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} track', other: '${count} tracks', ), 
			'library.albumCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} album', other: '${count} albums', ), 
			'library.deleteConfirmTitle' => 'Delete track?',
			'library.deleteConfirmMessage' => ({required Object title}) => '"${title}" will be permanently deleted from disk. This cannot be undone.',
			'library.deleteConfirmAction' => 'Delete',
			'library.deleted' => 'Track deleted',
			'library.deleteFailed' => 'Couldn\'t delete the track',
			'library.deleteConfirmTitleBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Delete ${count} track?', other: 'Delete ${count} tracks?', ), 
			'library.deleteConfirmMessageBatch' => 'The selected tracks will be permanently deleted from disk. This cannot be undone.',
			'library.deletedBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} track deleted', other: '${count} tracks deleted', ), 
			'library.deleteFailedBatch' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Couldn\'t delete ${count} track', other: 'Couldn\'t delete ${count} tracks', ), 
			'player.play' => 'Play',
			'player.pause' => 'Pause',
			'player.next' => 'Next track',
			'player.previous' => 'Previous track',
			'player.miniPlayerEmpty' => 'Play something - it will show up here',
			'player.playNext' => 'Play next',
			'player.addToQueue' => 'Add to queue',
			'player.queue' => 'Queue',
			'player.queueEmpty' => 'The queue is empty',
			'player.removeFromQueue' => 'Remove from queue',
			'player.nowPlaying' => 'Now playing',
			'player.closePlayer' => 'Close player',
			'player.shuffle' => 'Shuffle',
			'player.repeatOff' => 'Repeat off',
			'player.repeatAll' => 'Repeat all',
			'player.repeatOne' => 'Repeat one',
			'playlists.create' => 'New playlist',
			'playlists.rename' => 'Rename playlist',
			'playlists.delete' => 'Delete',
			'playlists.deleteConfirmTitle' => 'Delete playlist?',
			'playlists.deleteConfirmMessage' => ({required Object name}) => '"${name}" will be deleted. Its tracks stay in the library.',
			'playlists.deleteConfirmAction' => 'Delete',
			'playlists.nameLabel' => 'Name',
			'playlists.nameEmpty' => 'Enter a name',
			'playlists.empty' => 'No playlists yet',
			'playlists.emptyHint' => 'Create your first playlist',
			'playlists.trackCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} track', other: '${count} tracks', ), 
			'playlists.addToPlaylist' => 'Add to playlist',
			'playlists.emptyPlaylist' => 'No tracks yet',
			'playlists.emptyPlaylistHint' => 'Add tracks via long-press in the library',
			'playlists.removeFromPlaylist' => 'Remove from playlist',
			'playlists.addTracks' => 'Add tracks',
			'playlists.addTracksCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Add ${count} track', other: 'Add ${count} tracks', ), 
			'playlists.addedCount' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${count} track added', other: '${count} tracks added', ), 
			'favorites.addToFavorites' => 'Add to favorites',
			'favorites.removeFromFavorites' => 'Remove from favorites',
			'favorites.empty' => 'No favorites yet',
			'favorites.emptyHint' => 'Tap the heart in the player or in a track\'s menu',
			'search.title' => 'Search',
			'search.hint' => 'Tracks, albums, artists',
			'search.clear' => 'Clear',
			'search.startHint' => 'Search your library',
			'search.noResults' => ({required Object query}) => 'Nothing found for "${query}"',
			'search.filterTracks' => 'Filter tracks',
			'selection.selectedCount' => ({required Object count}) => '${count} selected',
			_ => null,
		};
	}
}
