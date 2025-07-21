import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/models/navigation_item.dart';
import 'package:reponsive_design/viewmodels/navigation_viewmodel.dart';

import 'navigation_viewmodel_test.mocks.dart';

@GenerateMocks([INavigationService])
void main() {
  group('NavigationViewModel Tests', () {
    late NavigationViewModel viewModel;
    late MockINavigationService mockNavigationService;
    late List<NavigationItem> testNavigationItems;

    setUp(() {
      mockNavigationService = MockINavigationService();

      // Create test navigation items
      testNavigationItems = [
        const NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        ),
        const NavigationItem(
          id: 'profile',
          title: 'Profile',
          icon: Icons.person,
          route: '/profile',
        ),
        const NavigationItem(
          id: 'settings',
          title: 'Settings',
          icon: Icons.settings,
          route: '/settings',
        ),
      ];

      // Setup mock behavior
      when(
        mockNavigationService.getNavigationItems(),
      ).thenReturn(testNavigationItems);

      viewModel = NavigationViewModel(mockNavigationService);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization', () {
      test('should initialize with no selected item', () {
        expect(viewModel.selectedItem, isNull);
        expect(viewModel.selectedIndex, equals(-1));
      });

      test('should return navigation items from service', () {
        final items = viewModel.navigationItems;
        expect(items, equals(testNavigationItems));
        expect(items.length, equals(3));
      });
    });

    group('Item Selection', () {
      test('should select item and notify listeners', () {
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        final itemToSelect = testNavigationItems[0];
        viewModel.selectItem(itemToSelect);

        expect(viewModel.selectedItem, equals(itemToSelect));
        expect(listenerCalled, isTrue);
        verify(mockNavigationService.navigateToItem(itemToSelect)).called(1);
      });

      test('should not notify listeners when selecting same item', () {
        final itemToSelect = testNavigationItems[0];
        viewModel.selectItem(itemToSelect);

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        // Select the same item again
        viewModel.selectItem(itemToSelect);

        expect(listenerCallCount, equals(0));
        verify(mockNavigationService.navigateToItem(itemToSelect)).called(1);
      });

      test('should update selected index when item is selected', () {
        final itemToSelect = testNavigationItems[1];
        viewModel.selectItem(itemToSelect);

        expect(viewModel.selectedIndex, equals(1));
      });

      test('should check if item is selected correctly', () {
        final itemToSelect = testNavigationItems[0];
        viewModel.selectItem(itemToSelect);

        expect(viewModel.isItemSelected(itemToSelect), isTrue);
        expect(viewModel.isItemSelected(testNavigationItems[1]), isFalse);
      });
    });

    group('Selection by Index', () {
      test('should select item by valid index', () {
        viewModel.selectItemByIndex(1);

        expect(viewModel.selectedItem, equals(testNavigationItems[1]));
        expect(viewModel.selectedIndex, equals(1));
        verify(
          mockNavigationService.navigateToItem(testNavigationItems[1]),
        ).called(1);
      });

      test('should throw RangeError for negative index', () {
        expect(() => viewModel.selectItemByIndex(-1), throwsRangeError);
      });

      test('should throw RangeError for index out of bounds', () {
        expect(() => viewModel.selectItemByIndex(10), throwsRangeError);
      });
    });

    group('Selection by ID', () {
      test('should select item by valid ID', () {
        final result = viewModel.selectItemById('profile');

        expect(result, isTrue);
        expect(viewModel.selectedItem, equals(testNavigationItems[1]));
        verify(
          mockNavigationService.navigateToItem(testNavigationItems[1]),
        ).called(1);
      });

      test('should return false for invalid ID', () {
        final result = viewModel.selectItemById('nonexistent');

        expect(result, isFalse);
        expect(viewModel.selectedItem, isNull);
        verifyNever(mockNavigationService.navigateToItem(any));
      });
    });

    group('Clear Selection', () {
      test('should clear selection and notify listeners', () {
        // First select an item
        viewModel.selectItem(testNavigationItems[0]);
        expect(viewModel.selectedItem, isNotNull);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.clearSelection();

        expect(viewModel.selectedItem, isNull);
        expect(viewModel.selectedIndex, equals(-1));
        expect(listenerCalled, isTrue);
      });

      test(
        'should not notify listeners when clearing already null selection',
        () {
          expect(viewModel.selectedItem, isNull);

          int listenerCallCount = 0;
          viewModel.addListener(() {
            listenerCallCount++;
          });

          viewModel.clearSelection();

          expect(listenerCallCount, equals(0));
        },
      );
    });

    group('Edge Cases', () {
      test('should handle empty navigation items list', () {
        when(mockNavigationService.getNavigationItems()).thenReturn([]);
        final emptyViewModel = NavigationViewModel(mockNavigationService);

        expect(emptyViewModel.navigationItems, isEmpty);
        expect(emptyViewModel.selectedIndex, equals(-1));
        expect(() => emptyViewModel.selectItemByIndex(0), throwsRangeError);

        emptyViewModel.dispose();
      });

      test('should handle selected item not in current navigation items', () {
        // Select an item first
        viewModel.selectItem(testNavigationItems[0]);
        expect(viewModel.selectedIndex, equals(0));

        // Change the navigation items to not include the selected item
        final newItems = [testNavigationItems[1], testNavigationItems[2]];
        when(mockNavigationService.getNavigationItems()).thenReturn(newItems);

        // The selected index should return -1 since the selected item is not in the list
        expect(viewModel.selectedIndex, equals(-1));
      });
    });

    group('Listener Management', () {
      test('should properly manage listeners', () {
        int listenerCallCount = 0;
        void listener() {
          listenerCallCount++;
        }

        viewModel.addListener(listener);
        viewModel.selectItem(testNavigationItems[0]);
        expect(listenerCallCount, equals(1));

        viewModel.removeListener(listener);
        viewModel.selectItem(testNavigationItems[1]);
        expect(listenerCallCount, equals(1)); // Should not increase
      });
    });
  });
}
