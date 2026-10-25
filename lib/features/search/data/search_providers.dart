import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:sync_music/features/library/data/library_providers.dart';
import 'package:sync_music/features/search/domain/search_results.dart';

/// One search = three parallel library queries folded via the Dart 3
/// record `.wait`. Keyed by the DEBOUNCED query (SearchQueryController),
/// so typing costs at most ~4 fetches/second and abandoned prefixes are
/// just unused family entries.
final FutureProviderFamily<SearchResults, String> searchResultsProvider =
    FutureProvider.family<SearchResults, String>((ref, query) async {
      if (query.trim().isEmpty) return const SearchResults.empty();

      final repository = ref.watch(libraryRepositoryProvider);
      final (tracks, albums, artists) = await (
        repository.searchTracks(query),
        repository.searchAlbums(query),
        repository.searchArtists(query),
      ).wait;
      return SearchResults(tracks: tracks, albums: albums, artists: artists);
    });
