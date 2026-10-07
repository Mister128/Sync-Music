import 'package:path/path.dart' as p;

/// Extensions we treat as music. Must stay a SUBSET of what
/// audio_metadata_reader can parse;
const Set<String> audioExt = {
  '.mp3',
  '.ogg',
  '.wav',
  '.flac',
  '.ape',
  '.aac',
  '.opus',
  '.m4a',
  '.aif',
  '.aiff',
};

bool isAudioFile(String path) =>
    audioExt.contains(p.extension(path.toLowerCase()));
