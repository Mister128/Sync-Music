import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/selection/selection_controller.dart';

void main() {
  group('SelectionController', () {
    late ProviderContainer container;
    late SelectionController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(selectionControllerProvider.notifier);
    });

    tearDown(() => container.dispose());

    Set<String> selection() => container.read(selectionControllerProvider);

    test('starts empty and inactive', () {
      expect(selection(), isEmpty);
      expect(controller.isActive, isFalse);
    });

    test('toggle adds, second toggle removes', () {
      controller.toggle('a');
      expect(selection(), {'a'});
      expect(controller.isActive, isTrue);

      controller.toggle('a');
      expect(selection(), isEmpty);
      expect(controller.isActive, isFalse);
    });

    test('keeps insertion order (batch enqueue relies on it)', () {
      controller
        ..toggle('c')
        ..toggle('a')
        ..toggle('b');
      expect(selection().toList(), ['c', 'a', 'b']);
    });

    test('emits a NEW set instance on every toggle', () {
      final before = selection();
      controller.toggle('a');
      expect(identical(before, selection()), isFalse);
    });

    test('selectAll replaces the previous selection', () {
      controller
        ..toggle('a')
        ..selectAll(['x', 'y', 'x']);
      expect(selection(), {'x', 'y'});
    });

    test('clear empties the selection', () {
      controller
        ..selectAll(['a', 'b'])
        ..clear();
      expect(selection(), isEmpty);
    });
  });
}
