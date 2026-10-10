abstract final class Routes {
  static const home = '/';
  static const settings = '/settings';

  static const albumDetail = '/album';
  static const artistDetail = '/artist';

  static String albumPath({
    required String albumTitle,
  }) =>
      '/album?${Uri(queryParameters: {'title': albumTitle}).query}';

  static String artistPath(String artistName) =>
      '/artist?${Uri(queryParameters: {'name': artistName}).query}';

  // Section paths are NOT routes
  static const favorites = '/favorites';
  static const playlists = '/playlists';
  static const tracks = '/tracks';
  static const albums = '/albums';
  static const artists = '/artists';
}
