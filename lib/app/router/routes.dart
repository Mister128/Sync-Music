abstract final class Routes {
  static const home = '/';
  static const settings = '/settings';

  static const addTracks = '/add-tracks';
  static const albumDetail = '/album';
  static const artistDetail = '/artist';
  static const playlistDetail = '/playlist';
  static const queue = '/queue';
  static const player = '/player';

  static String addTracksPath(String playlistId) =>
      '/add-tracks?${Uri(queryParameters: {'id': playlistId}).query}';

  static String albumPath({required String albumTitle}) =>
      '/album?${Uri(queryParameters: {'title': albumTitle}).query}';

  static String artistPath(String artistName) =>
      '/artist?${Uri(queryParameters: {'name': artistName}).query}';

  static String playlistPath({required String id, required String name}) =>
      '/playlists?${Uri(queryParameters: {"id": id, "name": name}).query}';

  // Section paths are NOT routes
  static const favorites = '/favorites';
  static const playlists = '/playlists';
  static const tracks = '/tracks';
  static const albums = '/albums';
  static const artists = '/artists';
}
