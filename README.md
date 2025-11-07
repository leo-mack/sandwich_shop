# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart, and it is designed primarily to be run in a web
# Sandwich Shop (Flutter)

A small, educational Flutter app for ordering sandwiches. It demonstrates a simple product
selector UI, quantity controls, and basic UI patterns useful for learning Flutter state
management and widgets.

This project is stored in the repository: https://github.com/leo-mack/shoe_shop3

## Key features

- Select between three sandwich types: Footlong, BLT, and Club.
- Three-button selector in the center (previous/current/next) with a Slider to jump between options.
- Add / Remove quantity buttons with bounds (disabled at 0 and at a configurable max).
- Simple, single-screen UI implemented in `lib/main.dart` for easy experimentation.

---

## 1. Installation & Setup

Prerequisites
- OS: Windows, macOS, or Linux. (Project contains platform folders for Android, iOS, Web, Windows, macOS, and Linux.)
- Flutter SDK (>= stable). Install from https://flutter.dev and run `flutter doctor` to verify.
- Git (for cloning the repo).
- An IDE such as Visual Studio Code or Android Studio (recommended).

Clone the repository

Use PowerShell (Windows) or your preferred shell:

```powershell
# clone the repository (replace with your repo URL if needed)
git clone https://github.com/leo-mack/shoe_shop3.git
cd shoe_shop3
git checkout 2
```

Install dependencies

```powershell
flutter pub get
```

Run the app

Run on the default device (connected device or emulator):

```powershell
flutter run
```

Or run on a specific device (e.g., Chrome or Windows):

```powershell
flutter devices
flutter run -d chrome
# or
flutter run -d windows
```

Run tests

```powershell
flutter test
```

---

## 2. Usage

Main flows

- When the app opens you see the currently selected sandwich and its quantity.
- Use the three centered buttons to view the previous, current, and next sandwich options.
- Slide the Slider control to jump between the three sandwich options (Footlong, BLT, Club).
- Use Add and Remove to increase or decrease the quantity. Add is disabled at the configured maximum (default 5 from `App` widget), Remove is disabled at 0.

Notes on behavior
- The app keeps a single shared quantity value (not per-sandwich). If you switch sandwiches the quantity shown is the same value. If you'd like separate quantities per sandwich I can implement a map or list to store quantities per item.

Screenshots / GIFs
- Replace these placeholders with actual screenshots from your device.

![Main screen - selection and quantity](assets/screenshots/main-screen.png)

GIF idea: show sliding the slider and tapping Add/Remove.

---

## 3. Project structure

Top-level folders you will see in the repo:

- `lib/` — main application Dart code. Key file: `lib/main.dart` (app entry and UI).
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` — platform-specific project files for building on each platform.
- `test/` — unit & widget tests (contains `widget_test.dart`).
- `images/` — app image assets (if used).
- `pubspec.yaml` — Flutter package configuration and dependencies.

Key file: `lib/main.dart`

- Implements `OrderScreen` (stateful) which manages the selected sandwich and quantity.
- `OrderItemDisplay` (stateless) shows the currently selected sandwich and the quantity.

Dependencies

- This is a vanilla Flutter app and uses only Flutter SDK (no third-party packages required).

Development tools

- Visual Studio Code (recommended) with Flutter and Dart extensions.
- Flutter CLI tools (`flutter pub get`, `flutter run`, `flutter test`).

---

## 4. Known issues & limitations

- Single global quantity: quantities are not tracked per sandwich — switching sandwiches keeps the same quantity. This was a design simplification.
- No persistent storage: app does not save orders between sessions.
- Accessibility & internationalization are not implemented.
- UI is intentionally minimal and not production-ready — it's meant as an educational demo.

Planned improvements
- Add per-sandwich quantities (store a map of quantities keyed by sandwich name).
- Persist orders locally (shared_preferences or sqlite).
- Add images for each sandwich and richer product details.
- Add responsive layout and accessibility improvements.

Contributing

- Fork the repository, create a feature branch, and open a Pull Request.
- Keep changes small and focused. Add or update tests where appropriate.
- Please include a short description of what you changed and why.

---

## 5. Contact

- Repo owner / main contact: leo-mack — https://github.com/leo-mack

- Email: `leo.m4ck@gmail.com`