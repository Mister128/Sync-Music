import 'package:talker/talker.dart';

/// App-wide logger entry point. Modules never create their own Talker -
/// they ask for a scoped logger: AppLogger.scope('sync.engine').
abstract final class AppLogger {
  static late final Talker instance;

  static void init() {
    instance = Talker();
  }

  static ScopedLogger scope(String tag) => ScopedLogger._(tag, instance);
}

/// Tiny wrapper: `[scanner] found 120 files` instead of `found 120 files`.
class ScopedLogger {
  const new _(this._tag, this._talker);

  final String _tag;
  final Talker _talker;

  void debug(Object? message) => _talker.debug('[$_tag] $message');

  void info(Object? message) => _talker.info('[$_tag] $message');

  void warn(Object? message) => _talker.warning('[$_tag] $message');

  void error(Object? message, [Object? error, StackTrace? stackTrace]) =>
      _talker.error('[$_tag] $message', error, stackTrace);
}
