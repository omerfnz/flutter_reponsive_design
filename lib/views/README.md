# Views Directory

This directory contains UI components (Views) that make up the user interface of the application.

## Structure

- Views should be stateless widgets when possible
- Views should use Consumer widgets to listen to ViewModel changes
- Views should follow the single responsibility principle
- Views should be responsive and adapt to different screen sizes

## Views to be implemented:

1. **ResponsiveLayoutView** - Main layout wrapper that handles responsive behavior
2. **NavigationRailView** - Navigation rail for desktop/tablet screens
3. **NavigationDrawerView** - Navigation drawer for mobile screens
4. **MainContentView** - Main content area with responsive grid
5. **GridContentView** - Grid content with dynamic column support

Each view will be implemented in subsequent tasks according to the MVVM architecture pattern.