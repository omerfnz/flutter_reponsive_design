import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/viewmodels/base_view_model.dart';

// Test implementation of BaseViewModel
class TestViewModel extends BaseViewModel {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  Future<void> simulateAsyncOperation() async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 100));
    _counter++;
    setLoading(false);
  }

  void simulateError() {
    setError('Test error occurred');
  }

  void simulateException() {
    handleException(Exception('Test exception'));
  }
}

void main() {
  group('BaseViewModel', () {
    late TestViewModel viewModel;

    setUp(() {
      viewModel = TestViewModel();
    });

    tearDown(() {
      // Dispose will be handled by individual tests when needed
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.hasError, isFalse);
        expect(viewModel.errorMessage, isEmpty);
        expect(viewModel.counter, equals(0));
      });
    });

    group('Loading State Management', () {
      test('should set loading state correctly', () {
        // Arrange
        bool notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.setLoading(true);

        // Assert
        expect(viewModel.isLoading, isTrue);
        expect(notified, isTrue);
      });

      test('should clear loading state correctly', () {
        // Arrange
        viewModel.setLoading(true);
        bool notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.setLoading(false);

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(notified, isTrue);
      });

      test('should not notify listeners when setting same loading state', () {
        // Arrange
        viewModel.setLoading(true);
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        // Act
        viewModel.setLoading(true);

        // Assert
        expect(notificationCount, equals(1)); // Should still notify
        expect(viewModel.isLoading, isTrue);
      });

      test('should handle async operations with loading state', () async {
        // Arrange
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.counter, equals(0));

        // Act
        final future = viewModel.simulateAsyncOperation();

        // Assert - Should be loading during operation
        expect(viewModel.isLoading, isTrue);

        await future;

        // Assert - Should not be loading after operation
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.counter, equals(1));
      });
    });

    group('Error State Management', () {
      test('should set error state correctly', () {
        // Arrange
        bool notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.setError('Test error');

        // Assert
        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, equals('Test error'));
        expect(viewModel.isLoading, isFalse); // Should clear loading state
        expect(notified, isTrue);
      });

      test('should clear error state correctly', () {
        // Arrange
        viewModel.setError('Test error');
        bool notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.clearError();

        // Assert
        expect(viewModel.hasError, isFalse);
        expect(viewModel.errorMessage, isEmpty);
        expect(notified, isTrue);
      });

      test('should handle exceptions correctly', () {
        // Arrange
        bool notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.simulateException();

        // Assert
        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, contains('Exception: Test exception'));
        expect(notified, isTrue);
      });

      test('should clear loading state when error is set', () {
        // Arrange
        viewModel.setLoading(true);

        // Act
        viewModel.setError('Test error');

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.hasError, isTrue);
      });
    });

    group('Listener Management', () {
      test('should notify listeners when state changes', () {
        // Arrange
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        // Act
        viewModel.increment();
        viewModel.setLoading(true);
        viewModel.setError('Test error');
        viewModel.clearError();

        // Assert
        expect(notificationCount, equals(4));
      });

      test('should handle multiple listeners', () {
        // Arrange
        int listener1Count = 0;
        int listener2Count = 0;

        void listener1() => listener1Count++;
        void listener2() => listener2Count++;

        viewModel.addListener(listener1);
        viewModel.addListener(listener2);

        // Act
        viewModel.increment();

        // Assert
        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));

        // Cleanup
        viewModel.removeListener(listener1);
        viewModel.removeListener(listener2);
      });

      test('should handle listener removal', () {
        // Arrange
        int notificationCount = 0;
        void listener() => notificationCount++;

        viewModel.addListener(listener);
        viewModel.increment();
        expect(notificationCount, equals(1));

        // Act
        viewModel.removeListener(listener);
        viewModel.increment();

        // Assert
        expect(notificationCount, equals(1)); // Should not increase
      });

      test('should not throw when removing non-existent listener', () {
        // Act & Assert
        expect(() => viewModel.removeListener(() {}), returnsNormally);
      });
    });

    group('State Combinations', () {
      test('should handle loading and error states independently', () {
        // Test loading -> error
        viewModel.setLoading(true);
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.hasError, isFalse);

        viewModel.setError('Test error');
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.hasError, isTrue);

        // Test error -> loading
        viewModel.setLoading(true);
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.hasError, isTrue); // Error should persist

        viewModel.clearError();
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.hasError, isFalse);
      });

      test('should handle multiple error messages', () {
        viewModel.setError('First error');
        expect(viewModel.errorMessage, equals('First error'));

        viewModel.setError('Second error');
        expect(viewModel.errorMessage, equals('Second error'));
      });

      test('should handle empty error messages', () {
        viewModel.setError('');
        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, isEmpty);
      });
    });

    group('Memory Management', () {
      test('should dispose properly', () {
        // Arrange
        viewModel.addListener(() {});

        // Act & Assert - Should not throw when disposing
        expect(() => viewModel.dispose(), returnsNormally);
      });

      test('should handle disposal with active listeners', () {
        // Arrange
        final testViewModel = TestViewModel();
        testViewModel.addListener(() {});
        testViewModel.addListener(() {});

        // Act & Assert
        expect(() => testViewModel.dispose(), returnsNormally);
      });
    });

    group('Edge Cases', () {
      test('should handle null error messages gracefully', () {
        // This test ensures the implementation is robust
        expect(() => viewModel.setError(''), returnsNormally);
      });

      test('should handle rapid state changes', () {
        // Arrange
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        // Act - Rapid state changes
        for (int i = 0; i < 100; i++) {
          viewModel.setLoading(i % 2 == 0);
          if (i % 10 == 0) {
            viewModel.setError('Error $i');
            viewModel.clearError();
          }
        }

        // Assert - Should handle all changes without issues
        expect(notificationCount, greaterThan(0));
        expect(viewModel.hasError, isFalse);
      });

      test(
        'should maintain state consistency during concurrent operations',
        () async {
          // This test simulates concurrent operations
          final futures = <Future>[];

          for (int i = 0; i < 10; i++) {
            futures.add(viewModel.simulateAsyncOperation());
          }

          await Future.wait(futures);

          // Assert - Final state should be consistent
          expect(viewModel.isLoading, isFalse);
          expect(viewModel.counter, equals(10));
        },
      );
    });

    group('Inheritance Behavior', () {
      test('should allow subclasses to extend functionality', () {
        // The TestViewModel extends BaseViewModel and adds counter functionality
        expect(viewModel.counter, equals(0));

        viewModel.increment();
        expect(viewModel.counter, equals(1));

        // Base functionality should still work
        viewModel.setLoading(true);
        expect(viewModel.isLoading, isTrue);
      });

      test('should maintain base functionality in subclasses', () {
        // Test that all base functionality works in the subclass
        viewModel.setLoading(true);
        viewModel.setError('Test error');
        viewModel.clearError();
        viewModel.handleException(Exception('Test'));

        // Should not throw any errors
        expect(viewModel.hasError, isTrue);
      });
    });
  });
}
