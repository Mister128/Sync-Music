/// What happens when the queue ends. Domain-level; the data layer maps it
/// onto just_audio's LoopMode.
enum RepeatMode { off, one, all }

extension RepeatModeCycle on RepeatMode {
  /// The cycle order used by BOTH the full-player button and the
  /// notification's custom action: off -> all -> one -> off
  RepeatMode get next => switch (this) {
    RepeatMode.off => RepeatMode.all,
    RepeatMode.all => RepeatMode.one,
    RepeatMode.one => RepeatMode.off,
  };
}
