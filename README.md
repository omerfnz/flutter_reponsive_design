# Flutter Responsive Design Template

https://raw.githubusercontent.com/omerfnz/flutter_reponsive_design/refs/heads/master/video.gif

A modern, production-ready Flutter template that provides a robust, scalable, and maintainable foundation for building responsive apps across mobile, tablet, desktop, and web platforms. Built with MVVM architecture, SOLID principles, and best practices for clean code, accessibility, and performance.

---

## Features
- **Fully Responsive**: Adapts automatically to mobile, tablet, desktop, and web screen sizes
- **MVVM Architecture**: Clean separation of UI, business logic, and data
- **SOLID Principles**: Maintainable, extensible, and testable codebase
- **NavigationRail & Drawer**: Dynamic navigation for different screen sizes
- **Responsive Grid System**: 2/4/6 columns based on device
- **Accessibility**: Semantic labels, keyboard navigation, screen reader support
- **Error Handling**: User-friendly error widgets and fallback mechanisms
- **Unit & Widget Tests**: High test coverage for all layers
- **Minimum Window Size**: On Windows, the app window cannot be resized below 400x400 px (see below)

---

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/omerfnz/flutter_reponsive_design.git
   cd flutter_reponsive_design
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```
   - For Windows: `flutter run -d windows`
   - For Web: `flutter run -d chrome`

---

## Usage
- On screens wider than 800dp, the NavigationRail is shown; on smaller screens, a Drawer is used.
- The main content area displays a responsive grid with sample items based on the selected route.
- Keyboard navigation and screen reader support are built-in for accessibility.
- On Windows, the app window cannot be resized below 500x500 px (see [windows/runner/win32_window.cpp](windows/runner/win32_window.cpp)).

---

## Architecture
- **View Layer:**
  - `ResponsiveLayoutView`, `NavigationRailView`, `NavigationDrawerView`, `MainContentView`, `GridContentView`
- **ViewModel Layer:**
  - `NavigationViewModel`, `ResponsiveViewModel`, `ContentViewModel`
- **Model Layer:**
  - `NavigationItem`, `BreakpointConfig`, `GridConfig`
- **Service Layer:**
  - `ResponsiveService`, `NavigationService`, `ContentService`
- **State Management:**
  - Provider + ChangeNotifier

---

## Responsive & Accessibility Notes
- **Responsive Grid:**
  - 2 columns on mobile, 4 on tablet, 6 on desktop
  - Uses `SliverGridDelegateWithMaxCrossAxisExtent` for flexible layouts
- **Accessibility:**
  - All navigation and grid items have semantic labels
  - Keyboard navigation is supported (arrow keys, tab)
  - Screen reader friendly
- **Minimum Window Size (Windows):**
  - The app cannot be resized below 400x400 px (see [windows/runner/win32_window.cpp](windows/runner/win32_window.cpp))

---

## Contribution
Contributions are welcome! Please open an issue or submit a pull request.

---

## License
MIT

---

**Author:** [omerfnz](https://github.com/omerfnz)
